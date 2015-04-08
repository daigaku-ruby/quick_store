# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quick_store/version'

Gem::Specification.new do |spec|
  spec.name          = "quick_store"
  spec.version       = QuickStore::VERSION
  spec.authors       = ["Paul Götze"]
  spec.email         = ["paul.christoph.goetze@gmail.com"]
  spec.summary       = %q{Simple local key-value store based on YAML::Store.}
  spec.description   = %q{Simple local key-value store based on YAML::Store.}
  spec.homepage      = "https://github.com/daigaku-ruby/quick_store"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
