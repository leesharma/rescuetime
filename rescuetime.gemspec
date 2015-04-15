# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rescuetime/version'

Gem::Specification.new do |spec|
  spec.name          = 'rescuetime'
  spec.version       = Rescuetime::VERSION
  spec.authors       = ['Lee Sharma']
  spec.email         = ['lee@leesharma.com']

  spec.summary       = %q{Ruby interface for RescueTime}
  spec.description   = %q{rescuetime is a simple ruby interface for the RescueTime Data Analytics API.}
  spec.homepage      = 'https://github.com/leesharma/rescuetime'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'simplecov'
end
