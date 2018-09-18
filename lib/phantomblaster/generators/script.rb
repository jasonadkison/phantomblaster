require 'thor/group'

module Phantomblaster
  module Generators
    class Script < Thor::Group
      include Thor::Actions
      argument :filename, type: :string

      def self.source_root
        File.dirname(__FILE__) + '/script'
      end

      def create_scripts_dir
        empty_directory(Phantomblaster.configuration.scripts_dir)
      end

      def copy_script
        template('script.js', "#{Phantomblaster.configuration.scripts_dir}/#{filename}")
      end
    end
  end
end
