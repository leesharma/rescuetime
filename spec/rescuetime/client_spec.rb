require 'spec_helper'

describe Rescuetime::Client do
  it 'exists' do
    expect(subject).not_to be_nil
  end

  describe '#api_key?' do
    it 'returns true if the api key is present' do
      client = Rescuetime::Client.new(api_key: 'key')
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
end