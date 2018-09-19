# Phantomblaster

A ruby gem for interacting with the [Phantombuster](https://phantombuster.com) service.

Currently includes a CLI tool to make it easier to develop and work with agent scripts. In the future, it will provide an easy way to interact with agents from within any ruby program.

[![Gem Version](https://badge.fury.io/rb/phantomblaster.svg)](https://badge.fury.io/rb/phantomblaster)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'phantomblaster'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phantomblaster

## Usage

```
  phantomblaster account            # Displays information about the account
  phantomblaster agents             # Lists all remote agents
  phantomblaster download FILENAME  # Downloads an agent script
  phantomblaster generate FILENAME  # Generates an agent script
  phantomblaster help [COMMAND]     # Describe available commands or one specific command
  phantomblaster pull               # Fetches all agent scripts
  phantomblaster push               # Pushes all agent scripts
  phantomblaster scripts            # Lists all remote scripts
  phantomblaster upload FILENAME    # Uploads an agent script
```

## Configuration

There are currently 2 options available.

You can configure options by creating an initializer:

```ruby
Phantomblaster.configure do |config|
  config.api_key = 'XXXXXXXXX'
  config.scripts_dir = '/path/to/scripts'
end
```

Or set the following environment variables:

* PHANTOMBUSTER_API_KEY
* PHANTOMBUSTER_SCRIPTS_DIR

The scripts directory must be an absolute path.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jasonadkison/phantomblaster.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
