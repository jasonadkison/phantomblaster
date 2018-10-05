module Phantomblaster
  module Models
    class Script
      class << self
        def find(id)
          data = Phantomblaster::API.get_script(id: id)
          new(data)
        end

        def find_by_name(name)
          data = Phantomblaster::API.get_script(name: name)
          new(data)
        end

        def all
          data = Phantomblaster::API.get_scripts
          data.map { |params| new(params) }
        end

        def read_local(name)
          pathname = Pathname.new("#{Phantomblaster.configuration.scripts_dir}/#{name}")
          raise MissingFileError, "#{pathname.realdirpath} not found" unless pathname.file?

          pathname.open(&:read)
        end

        def upload(name)
          text = read_local(name)
          Phantomblaster::API.post_script(name, text)
        end
      end

      attr_reader :id, :name, :source, :last_saved_at

      def initialize(params)
        @id = params['id']
        @name = params['name']
        @source = params['source']
        @last_saved_at = params['lastSaveDate']
        @text = params['text'].to_s if params.key?('text')
      end

      def text
        @text ||= self.class.find(id).instance_variable_get(:@text)
      end

      def local_text
        @local_text ||= self.class.read_local(name)
      end
    end
  end
end
