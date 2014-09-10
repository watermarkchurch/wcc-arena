# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wcc/arena/version'

Gem::Specification.new do |spec|
  spec.name          = "wcc-arena"
  spec.version       = WCC::Arena::VERSION
  spec.authors       = ["Travis Petticrew", "Watermark Community Church"]
  spec.email         = ["travis@petticrew.net", "dev@watermark.org"]
  spec.description   = %q{Watermark's library for interfacing with Arena ChMS's web API}
  spec.summary       = File.readlines("README.md").join
  spec.homepage      = "https://github.com/watermarkchurch/wcc-arena"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.8.8"
  spec.add_dependency "nokogiri", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
end
