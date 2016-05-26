require 'spec_helper'
require 'rescuetime/formatters/array_formatter' # load explicitly

describe Rescuetime::Formatters::ArrayFormatter do
  let(:array_formatter) { Rescuetime::Formatters::ArrayFormatter }
  let(:report) {
    file = File.expand_path('../../../fixtures/sample_response_body.csv', __FILE__)
    CSV.new(File.read(file),
            headers: true,
            header_converters: :symbol,
            converters: :all)
  }

  describe '.name' do
    it 'returns "array"' do
      name = array_formatter.name
      expect(name).to eq 'array'
    end
  end

  describe '.format' do
    it 'returns an array of hashes' do
      array_report = array_formatter.format(report)
      expect(array_report).to be_an Array
      expect(array_report.first).to be_a Hash
    end
  end
end
