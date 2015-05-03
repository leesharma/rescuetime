require 'spec_helper'
require 'rspec/its'

describe Rescuetime::Client do
  it { is_expected.not_to be_nil }

  describe '#initialize' do
    describe 'when arguments are blank ()' do
      its(:api_key) { is_expected.to be nil }
    end
    describe 'when initialized with options (api_key: \'AK\')' do
      subject { Rescuetime::Client.new(api_key: 'AK') }
      its(:api_key) { is_expected.to eq('AK') }
    end
  end

  describe '#api_key?' do
    describe 'when key is present' do
      subject { Rescuetime::Client.new(api_key: 'AK') }
      its(:api_key?) { is_expected.to be true }
    end
    describe 'when key is nil' do
      its(:api_key?) { is_expected.to be false }
    end
    describe 'when key is blank' do
      subject { Rescuetime::Client.new(api_key: '') }
      its(:api_key?) { is_expected.to be false }
    end
  end

  describe '#api_key=' do
    before { subject.api_key = 'new api key' }
    it 'overwrites api key' do
      expect(subject.api_key).to eq('new api key')
    end
  end

  describe '#api_key' do
    it 'fetches api key' do
      subject.api_key = 'new api key'
      expect(subject.api_key).to eq('new api key')
    end
  end

  describe '#valid_credentials?' do
    describe 'when credentials are not present' do
      its(:valid_credentials?) { is_expected.to be false }
    end

    describe 'when credentials are invalid' do
      subject { Rescuetime::Client.new(api_key: 'invalid_key') }
      it 'returns false' do
        VCR.use_cassette('analytic data responses (no dates)') do
          expect(subject.valid_credentials?).to be false
        end
      end
    end

    describe 'when credentials are valid' do
      subject { Rescuetime::Client.new(api_key: 'AK') }
      it 'returns true' do
        VCR.use_cassette('analytic data responses (no dates)') do
          expect(subject.valid_credentials?).to be true
        end
      end
    end
  end

  describe '#fetch'
end
