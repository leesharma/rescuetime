require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

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

  # Put '<RESCUETIME_API_KEY>' so API key is not committed to source control
  config.filter_sensitive_data('<RESCUETIME_API_KEY>') { Secret::API_KEY }
end