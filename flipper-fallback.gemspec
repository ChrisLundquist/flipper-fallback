# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flipper/adapters/fallback'

Gem::Specification.new do |spec|
  spec.name          = "flipper-fallback"
  spec.version       = Flipper::Adapters::Fallback::VERSION
  spec.authors       = ["Chris Lundquist"]
  spec.email         = ["chris.lundquist@github.com"]
  spec.summary       = %q{Fallback to another flipper adapter when the primary one fails.}
  spec.description   = %q{Fallback to another flipper adapter when the primary one fails.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'flipper'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'flipper-redis'
  spec.add_development_dependency 'rspec', '< 3.0.0' #upstream
end
