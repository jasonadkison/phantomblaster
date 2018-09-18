require 'phantomblaster/version'
require 'phantomblaster/user'

# A module for containing phantombuster functionalities.
module Phantomblaster
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # Class that holds the config state for the gem.
  # Define each config option with a getter/setter.
  class Configuration
    attr_accessor :api_key

    def initialize
      @api_key = ENV['PHANTOMBUSTER_API_KEY'] || ''
    end
  end
end
