require 'spec_helper'

describe Rescuetime::Formatters::BaseFormatter do
  let(:base_formatter) { Rescuetime::Formatters::BaseFormatter }

  describe '.name' do
    it 'raises a NotImplementedError' do
      expect { base_formatter.name }.to raise_error NotImplementedError
    end
  end

  describe '.format' do
    it 'raises a NotImplementedError' do
      report = CSV.new('fake,csv,file')
      expect { base_formatter.format report }.to raise_error NotImplementedError
    end
  end

  describe '.descendents' do
    # Assumes the existance of ArrayFormatter and CSVFormatter
    it 'returns subclasses of the BaseFormatter' do
      descendents = base_formatter.descendents
      expect(descendents).to include Rescuetime::Formatters::ArrayFormatter
      expect(descendents).to include Rescuetime::Formatters::CSVFormatter
    end
  end
end
