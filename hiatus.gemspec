# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hiatus/version'

Gem::Specification.new do |spec|
  spec.name          = "hiatus"
  spec.version       = Hiatus::VERSION
  spec.authors       = ["Alex Gessner"]
  spec.email         = ["alex.gessner@gmail.com"]
  spec.summary       = "Use a key-value store to pause some of your functionality."
  spec.description   = "This is useful for such things as maintenance mode, testing, and heavy migrations."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "redis"
end
