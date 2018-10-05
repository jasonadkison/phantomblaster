require 'bundler/setup'
require 'phantomblaster'
require 'webmock/rspec'
require 'support/json_fixtures'
require 'support/phantomblaster_helpers'

ENV['GEM_ENV'] = 'test'
WebMock.disable_net_connect!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
