require 'spec_helper'

describe Rescuetime::Activities do
  before do
    @client = Rescuetime::Client.new do |config|
      config.api_key = 'AK'
    end
  end

  describe '#activities' do
    it 'exists' do
      expect(@client).to respond_to(:activities)
    end
    it 'returns list of activities' do
      VCR.use_cassette('default activities list') do
        expect(@client.activities).to be_instance_of(Array)
        expect(@client.activities[0]).to be_instance_of(Hash)
      end
    end
  end
end