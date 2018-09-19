require 'phantomblaster/version'
require 'phantomblaster/configuration'
require 'phantomblaster/errors'
require 'phantomblaster/client'
require 'phantomblaster/api'
require 'phantomblaster/models/user'
require 'phantomblaster/models/script'

# A module for containing phantombuster functionalities.
module Phantomblaster
  API_URL = 'https://phantombuster.com/api/v1'.freeze

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end

Phantomblaster.configure do |config|
  config.api_key = ENV['PHANTOMBUSTER_API_KEY']
  config.scripts_dir = ENV['PHANTOMBUSTER_SCRIPTS_DIR'] || File.join(File.dirname(__FILE__), '../scripts')
end
