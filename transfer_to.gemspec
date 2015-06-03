# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transfer_to/version'

Gem::Specification.new do |spec|
  spec.name          = "transfer_to"
  spec.version       = TransferTo::VERSION
  spec.authors       = ["Nikhil Gupta"]
  spec.email         = ["me@nikhgupta.com"]
  spec.description   = %q{Consumes TransferTo.com API and provides with ruby methods for the same}
  spec.summary       = %q{Gem to consume TransferTo.com API}
  spec.homepage      = "http://rubygems.org/gems/transfer_to"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", '~> 10.0'

  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "activesupport", "~> 4.1"

end
