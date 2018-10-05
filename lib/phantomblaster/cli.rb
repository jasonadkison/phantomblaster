require 'thor'
require 'terminal-table'
require 'pathname'
require 'diffy'
require 'phantomblaster/generators/script'

module Phantomblaster
  class CLI < Thor
    package_name 'phantomblaster'

    desc 'account', 'Displays information about the account'
    def account
      title = 'Phantombuster Account'
      headings = ['Email', 'API Key']
      rows = [[current_user.email, Phantomblaster.configuration.api_key]]
      table = Terminal::Table.new title: title, headings: headings, rows: rows
      say table
    end

    desc 'agents', 'Lists all remote agents'
    def agents
      title = 'Phantombuster Agents'
      headings = ['Agent Name', 'Agent ID', 'Script ID', 'Last Status']
      rows = []
      current_agents.each do |agent|
        rows << [agent['name'], agent['id'], agent['scriptId'], agent['lastEndStatus']]
      end
      table = Terminal::Table.new title: title, headings: headings, rows: rows
      say table
    end

    desc 'scripts', 'Lists all remote scripts'
    def scripts
      title = 'Phantombuster Scripts'
      headings = ['Script Name', 'Script ID', 'Script Source', 'Script Last Saved At']
      rows = []
      current_scripts.each do |script|
        rows << [script.name, script.id, script.source, script.last_saved_at]
      end
      table = Terminal::Table.new title: title, headings: headings, rows: rows
      say table
    end

    desc 'generate FILENAME', 'Generates an agent script'
    def generate(name)
      Phantomblaster::Generators::Script.start([name])
    end

    desc 'upload FILENAME', 'Uploads an agent script'
    def upload(name)
      begin
        @script = Phantomblaster::Models::Script.find_by_name(name)
        diff = Diffy::Diff.new(@script.text, @script.local_text)
        return say 'Local and remote scripts are identical.' if diff.to_s.empty?

        say diff.to_s(:color)
      rescue APIError => e
        raise e unless e.message.include?('404')

        say "Creating #{name} on Phantombuster."
      end

      return unless yes?('Continue?')

      res = Phantomblaster::Models::Script.upload(name)
      say res
    end

    desc 'download FILENAME', 'Downloads an agent script'
    def download(name, force = false)
      script = Phantomblaster::Models::Script.find_by_name(name)
      folder_pathname = Pathname.new(Phantomblaster.configuration.scripts_dir)
      file_pathname = Pathname.new(name)
      full_pathname = folder_pathname.join(file_pathname)

      unless folder_pathname.directory?
        return unless yes?("Directory #{folder_pathname.realdirpath} does not exist. Create it?")

        folder_pathname.mkpath
      end

      if !force && full_pathname.exist?
        return unless yes?("File #{full_pathname.realpath} already exists. Overwrite?")
      end

      full_pathname.open('w') { |f| f << script.text }
      say "Wrote #{full_pathname.realpath}"
    end

    desc 'pull', 'Fetches all agent scripts'
    def pull
      say 'This will pull all remote Phantombuster scripts.'
      say 'Existing scripts on your local file system will be overwritten!', :bold

      return unless yes?('Are you sure you want to continue?')

      current_scripts.each do |script|
        download(script.name, true)
      end
    end

    desc 'push', 'Pushes all agent scripts'
    def push
      say 'This will push all local file system scripts to Phantombuster.'
      say 'Existing scripts on Phantombuster will be overwritten!', :bold

      return unless yes?('Are you sure you want to continue?')

      folder_pathname = Pathname.new(Phantomblaster.configuration.scripts_dir)
      raise 'Scripts directory does not exist' unless folder_pathname.directory?

      Pathname.glob("#{folder_pathname.realdirpath}/**/*.js").each do |pn|
        _dir, file = pn.split
        upload(file)
      end
    end

    private

    def current_user
      @current_user ||= Phantomblaster::Models::User.find
    end

    def current_agents
      @current_agents ||= current_user.agents
    end

    def current_scripts
      @current_scripts ||= Phantomblaster::Models::Script.all
    end
  end
end
