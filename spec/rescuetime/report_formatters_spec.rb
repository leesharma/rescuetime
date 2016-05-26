require 'spec_helper'

describe Rescuetime::ReportFormatters do
  let(:report_formatters) { Rescuetime::ReportFormatters.new }

  describe '#all' do
    # Assumes existance of ArrayFormatter and CSVFormatter
    it 'returns a list of available formatter names' do
      all_names = report_formatters.all
      expect(all_names).to include 'array'
      expect(all_names).to include 'csv'
    end
  end

  describe '#find' do
    it 'returns the available formatter with the given name' do
      formatter = report_formatters.find('array')
      expect(formatter).to eq Rescuetime::Formatters::ArrayFormatter
    end

    it 'fails with an InvalidFormatError if the formatter name is not found' do
      expect {
        report_formatters.find('invalid')
      }.to raise_error Rescuetime::Errors::InvalidFormatError
    end
  end

  describe '#formatters' do
    it 'returns a list of formatters'
  end

  describe '#reload' do
    it 'forces a reload of the report formatter files'
  end
end
