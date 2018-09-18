require 'phantomblaster/version'
require 'phantomblaster/errors'
require 'phantomblaster/client'
require 'phantomblaster/models/user'
require 'phantomblaster/models/script'

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
    attr_accessor :api_key, :scripts_dir

    def initialize
      @api_key = ''
      @scripts_dir = ''
    end
  end
end

Phantomblaster.configure do |config|
  config.api_key = ENV['PHANTOMBUSTER_API_KEY']
  config.scripts_dir = ENV['PHANTOMBUSTER_SCRIPTS_DIR'] || File.join(File.dirname(__FILE__), '../scripts')
end
