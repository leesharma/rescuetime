# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rescuetime/version'

Gem::Specification.new do |spec|
  spec.name          = "rescuetime"
  spec.version       = Rescuetime::VERSION
  spec.authors       = ["Lee"]
  spec.email         = ["lee@leesharma.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{Simple Ruby SDK for RescueTime}
  spec.description   = %q{rescuetime is a simple ruby SDK for the RescueTime Data Analytics API.}
  spec.homepage      = 'https://github.com/leesharma/rescuetime'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'csv'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
