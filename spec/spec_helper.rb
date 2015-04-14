$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rescuetime'

require 'webmock/rspec'
require 'faraday'
require 'vcr'

require 'csv'

require 'secret'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock

  config.filter_sensitive_data('<RESCUETIME_API_KEY>') { Secret::API_KEY }
end