# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wcc/arena/version'

Gem::Specification.new do |spec|
  spec.name          = "wcc-arena"
  spec.version       = WCC::Arena::VERSION
  spec.authors       = ["Travis Petticrew"]
  spec.email         = ["travis@petticrew.net"]
  spec.description   = %q{Watermark's library for interfacing with the Arena ChMS API}
  spec.summary       = %q{Watermark's library for interfacing with the Arena ChMS API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.8.8"
  spec.add_dependency "nokogiri", "~> 1.6.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
