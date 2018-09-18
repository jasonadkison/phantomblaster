# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "phantomblaster/version"

Gem::Specification.new do |spec|
  spec.name          = "phantomblaster"
  spec.version       = Phantomblaster::VERSION
  spec.authors       = ["Jason Adkison"]
  spec.email         = ["jadkison@gmail.com"]
  spec.summary       = "A gem for interacting with Phantombuster agents."
  spec.description   = "A gem for interacting with Phantombuster agents. Allows you to easily " \
                       "manage, sync and consume agents from within your Ruby/Rails based " \
                       "applications."
  spec.homepage      = "https://github.com/jasonadkison/phantomblaster"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "commander", "~> 4.4"
  spec.add_runtime_dependency "terminal-table", "~> 1.8.0"
end
