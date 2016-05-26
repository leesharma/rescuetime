# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rescuetime/version'

Gem::Specification.new do |spec|
  spec.name          = 'rescuetime'
  spec.version       = Rescuetime::VERSION
  spec.authors       = ['Lee Sharma']
  spec.email         = ['lee@leesharma.com']

  spec.summary       = 'Ruby interface for RescueTime'
  spec.description   = 'Ruby interface for the RescueTime Data Analytics API.'
  spec.homepage      = 'https://github.com/leesharma/rescuetime'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
                                        .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.4', '>= 10.4.2'

  spec.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'vcr', '~> 2.9', '>= 2.9.3'
  spec.add_development_dependency 'webmock', '~> 1.21', '>= 1.21.0'
  spec.add_development_dependency 'timecop', '~> 0.8.0'
end
