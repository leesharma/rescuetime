require 'spec_helper'

describe Rescuetime::Client do
  it { is_expected.not_to be_nil }

  describe '#api_key?' do
    describe 'when a key is present' do
      subject { Rescuetime::Client.new(api_key: 'AK').api_key? }
      it { is_expected.to be true }
    end
    describe 'when a key is not present' do
      subject { Rescuetime::Client.new.api_key? }
      it { is_expected.to be false }
    end
  end

  describe '#api_key=' do
    it 'overwrites api key' do
      subject.api_key = 'new api key'
      expect(subject.instance_variable_get(:@api_key)).to eq('new api key')
    end
  end

  describe '#valid_credentials?' do
    describe 'if credentials are not present' do
      subject { Rescuetime::Client.new.valid_credentials? }
      it { is_expected.to be false }
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
