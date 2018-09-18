module Phantomblaster
  class CLI
    include Commander::Methods

    def initialize
      raise 'api key is not set' if Phantomblaster.configuration.api_key.nil?

      program :name, 'Phantomblaster'
      program :version, '0.1.0'
      program :description, 'Phantombuster api utility for listing, syncing and managing agents.'
    end

    def run
      command :key do |c|
        c.syntax = 'phantomblaster key'
        c.description = 'Prints the api key'
        c.action { say @api_key }
      end

      command :list do |c|
        c.syntax = 'phantombuster list'
        c.description = 'Lists all agents'
        c.action do
          headings = ['Agent ID', 'Agent Name']
          rows = []
          user.agents.each do |agent|
            rows << [agent['id'], agent['name']]
          end
          table = Terminal::Table.new headings: headings, rows: rows
          say table
        end
      end

      command :foo do |c|
        c.syntax = 'phantomblaster foo'
        c.description = 'Outputs "bar"'
        c.action do |args, options|
          say 'bar'
        end
      end

      default_command :help

      run!
    end

    def user
      @user ||= User.fetch
    end
  end
end
