$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rescuetime'

require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures'
  config.hook_into :webmock
end
