require 'spec_helper'

describe Rescuetime::DateParser do
  let(:parser) { Rescuetime::DateParser }

  describe '.parse' do
    context 'with input that responds to #strftime' do
      it 'returns a string in the YYYY-MM-DD format' do
        date = Date.parse('1776-07-04')
        datelike = Object.new
        allow(datelike).to receive(:strftime) { '1776-07-04' }

        expect(parser.parse(date)).to eq '1776-07-04'
        expect(parser.parse(datelike)).to eq '1776-07-04'
      end
    end

    context 'with a string in the YYYY-MM-DD foramt' do
      it 'returns a string in the YYYY-MM-DD format' do
        date = '1776-07-04'
        returned_date = parser.parse date
        expect(returned_date).to eq '1776-07-04'
      end
    end

    context 'with a string in the YYYY/MM/DD format' do
      it 'returns a string in the YYYY-MM-DD format' do
        date = '1776/07/04'
        returned_date = parser.parse date
        expect(returned_date).to eq '1776-07-04'
      end
    end

    context 'with a string in the MM-DD-YYYY format' do
      it 'returns a string in the YYYY-MM-DD format' do
        date = '07-04-1776'
        returned_date = parser.parse date
        expect(returned_date).to eq '1776-07-04'
      end
    end

    context 'with a string in the MM/DD/YYYY format' do
      it 'returns a string in the YYYY-MM-DD format' do
        date = '07/04/1776'
        returned_date = parser.parse date
        expect(returned_date).to eq '1776-07-04'
      end
    end

    context 'with a string in the MM-DD format' do
      it 'returns a string in the YYYY-MM-DD format' do
        date = '07-04'
        returned_date = parser.parse date
        expect(returned_date).to eq '2015-07-04'
      end
    end

    context 'with a string in the MM/DD format' do
      it 'returns a string in the YYYY-MM-DD format' do
        date = '07/04'
        returned_date = parser.parse date
        expect(returned_date).to eq '2015-07-04'
      end
    end

    context 'with an invalid date input' do
      it 'fails with an InvalidQueryError' do
        date = 'invalid'
        expect {
          parser.parse date
        }.to raise_error Rescuetime::Errors::InvalidQueryError
      end
    end
  end
end
