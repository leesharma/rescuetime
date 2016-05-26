require 'spec_helper'
require 'rescuetime/formatters/csv_formatter' # load explicitly

describe Rescuetime::Formatters::CSVFormatter do
  let(:csv_formatter) { Rescuetime::Formatters::CSVFormatter }
  let(:report) {
    file = File.expand_path('../../../fixtures/sample_response_body.csv', __FILE__)
    CSV.new(File.read(file),
            headers: true,
            header_converters: :symbol,
            converters: :all)
  }

  describe '.name' do
    it 'returns "csv"' do
      name = csv_formatter.name
      expect(name).to eq 'csv'
    end
  end

  describe '.format' do
    it 'returns a CSV' do
      csv_report = csv_formatter.format report
      expect(csv_report).to be_a CSV
    end
  end
end
