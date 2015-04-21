require 'spec_helper'

describe Rescuetime::Client do
  it 'exists' do
    expect(subject).not_to be_nil
  end

  describe '#api_key?' do
    it 'returns true if the api key is present' do
      client = Rescuetime::Client.new(api_key: 'AK')
      expect(client.api_key?).to be true
    end
    it 'returns false if the api key is not present' do
      client = Rescuetime::Client.new
      expect(client.api_key?).to be false
    end
  end

  describe '#api_key=' do
    it 'overwrites api key' do
      subject.api_key = 'new api key'
      expect(subject.instance_variable_get(:@api_key)).to eq('new api key')
    end
  end

  describe '#valid_credentials?' do
    it 'returns false if credentials are not present' do
      expect(subject.valid_credentials?).to eq(false)
    end
    it 'returns false if credentials are invalid' do
      VCR.use_cassette('invalid_credentials',
                       match_requests_on: [:host, :path], record: :none) do
        client = Rescuetime::Client.new(api_key: 'invalid_key')
        expect(client.valid_credentials?).to be(false)
      end
    end
    it 'returns true if credentials are valid' do
      VCR.use_cassette('/data?key=AK',
                       match_requests_on: [:host, :path], record: :none) do
        client = Rescuetime::Client.new(api_key: 'AK')
        expect(client.valid_credentials?).to be(true)
      end
    end
  end
end