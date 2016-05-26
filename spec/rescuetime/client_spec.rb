require 'spec_helper'

describe Rescuetime::Client do
  it { is_expected.not_to be_nil }

  describe '#initialize' do
    describe Rescuetime::Client.new do
      its(:api_key) { is_expected.to be nil }
    end
    describe Rescuetime::Client.new(api_key: 'AK') do
      its(:api_key) { is_expected.to eq('AK') }
    end
  end

  describe '#api_key?' do
    describe 'when key is present' do
      subject { Rescuetime::Client.new(api_key: 'AK') }
      its(:api_key?) { is_expected.to be true }
    end
    describe 'when key is nil' do
      subject { Rescuetime::Client.new(api_key: nil) }
      its(:api_key?) { is_expected.to be false }
    end
    describe 'when key is blank' do
      subject { Rescuetime::Client.new(api_key: '') }
      its(:api_key?) { is_expected.to be false }
    end
  end

  describe '#api_key=' do
    before { subject.api_key = 'new api key' }
    it { is_expected.to respond_to :api_key= }
    it { is_expected.to have_attributes(api_key: 'new api key') }
  end
  describe '#api_key' do
    it { is_expected.to respond_to :api_key }
  end

  describe '#valid_credentials?', vcr: true do
    let(:missing_key) { Rescuetime::Client.new }
    let(:invalid_key) { Rescuetime::Client.new(api_key: 'invalid_key') }
    let(:valid_key)   { Rescuetime::Client.new(api_key: Secret::API_KEY) }

    context 'with no credentials' do
      subject { missing_key }
      its(:valid_credentials?) { is_expected.to be false }
    end
    context 'with invalid credentials' do
      subject { invalid_key }
      its(:valid_credentials?) { is_expected.to be false }
    end
    context 'with valid credentials' do
      subject { valid_key }
      its(:valid_credentials?) { is_expected.to be true }
    end
  end
end
