begin
  # Test coverage reporters
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
  SimpleCov.start
rescue LoadError
  puts 'Codeclimate Test Reporter not installed. '\
  'Install gem codeclimate-test-reporter for coverage data.'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rescuetime'

require 'rspec'
require 'rspec/its'
require 'webmock/rspec'
require 'vcr'
require 'time'

# Stub the current date/time for the methods that rely on today
require 'timecop'
today = Time.parse '2015-05-04'
Timecop.freeze today

# Load the testing secrets (API key, etc.) for VCR recorded requests
begin
  require 'support/secret'
rescue LoadError
  require 'support/sample_secret'
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { record: :once }
  config.configure_rspec_metadata!

  config.ignore_hosts 'codeclimate.com'
  config.filter_sensitive_data('<RESCUETIME_API_KEY>') { Secret::API_KEY }
end

##
# HELPER METHODS
# --------------

# Collects invalid dates (determined by 'valid' regex) in a report by time and
# returns invalid date count
#
# @param  [Array<Hash>] activities array of activity hashes, each with key :date
# @param  [Regexp]      valid      regexp of valid dates ('YYYY-MM-DD' format)
# @return [Integer]                invalid date count
def count_invalid(activities, valid, key = :date)
  activities.collect { |activity| activity[key] }
            .delete_if { |date| date =~ valid }
            .count
end

# Returns activity keys from an activities array
#
# @param  [Array<Hash>] activities array of activity hashes
# @return [Array]                  activity keys
def collect_keys(activities)
  activities.first.keys
end

# Collects unique dates from an activities array where activities have a :date
#
# @param  [Array<Hash>] activities array of activity hashes, each with key :date
# @return [Array<Time>]            array of unique time objects
def unique_dates(activities)
  activities.collect { |activity| Time.parse activity[:date] }.uniq
end
