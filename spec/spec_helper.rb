require 'codeclimate-test-reporter'
require 'simplecov'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
]
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rescuetime'

require 'webmock/rspec'
require 'faraday'
require 'vcr'

require 'csv'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.ignore_hosts 'codeclimate.com'

  # Put '<RESCUETIME_API_KEY>' so API key is not committed to source control
  config.filter_sensitive_data('<RESCUETIME_API_KEY>') { 'AK' }
end