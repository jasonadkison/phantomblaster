module Phantomblaster
  class Configuration
    attr_accessor :api_key, :scripts_dir

    def initialize
      @api_key = ''
      @scripts_dir = ''
    end
  end
end
