require 'spec_helper'

describe Rescuetime::Configuration do
  describe '#formatter_paths' do
    it 'defaults to []' do
      config = subject
      expect(config.formatter_paths).to eq []
    end
  end

  describe '#formatter_paths=' do
    it 'can set a value' do
      config = subject
      config.formatter_paths = ['~/Desktop']
      expect(config.formatter_paths).to eq ['~/Desktop']
    end
  end
end
