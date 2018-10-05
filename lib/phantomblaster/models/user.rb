module Phantomblaster
  module Models
    class User
      class << self
        def find
          data = Phantomblaster::API.get_user
          new(data)
        end
      end

      attr_reader :email, :agents

      def initialize(params)
        @email = params['email']
        @agents = params['agents']
      end
    end
  end
end
