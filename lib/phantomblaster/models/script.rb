module Phantomblaster
  module Models
    class Script
      def self.find(id)
        data = Phantomblaster::API.get_script(id: id)
        new(data)
      end

      def self.find_by_name(name)
        data = Phantomblaster::API.get_script(name: name)
        new(data)
      end

      def self.all
        data = Phantomblaster::API.get_scripts
        data.map { |params| new(params) }
      end

      def self.upload(name)
        pathname = Pathname.new("#{Phantomblaster.configuration.scripts_dir}/#{name}")
        raise MissingFileError, "#{pathname.realdirpath} not found" unless pathname.file?

        text = pathname.open(&:read)
        Phantomblaster::API.post_script(name, text)
      end

      attr_reader :id, :name, :source, :last_saved_at

      def initialize(params)
        @id = params['id']
        @name = params['name']
        @source = params['source']
        @last_saved_at = params['lastSaveDate']
        @text = params['text'].to_s
      end

      def text
        @text ||= self.class.find(id).instance_variable_get(:@text)
      end
    end
  end
end
