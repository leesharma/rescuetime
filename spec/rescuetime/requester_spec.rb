require 'spec_helper'

describe Rescuetime::Requester, vcr: true do
  let(:requester) { Rescuetime::Requester }
  let(:host) { Rescuetime::Collection::HOST }

  describe '#get' do
    it 'returns a response body'

    context 'no api key is present' do
      it 'raises a missing credentials error' do
        expect {
          requester.get host, {}
        }.to raise_error Rescuetime::Errors::MissingCredentialsError
      end
    end

    context 'api key is incorrect' do
      it 'raises an invalid credentials error' do
        invalid_key = 'INVALID KEY'

        expect {
          requester.get host, key: invalid_key
        }.to raise_error Rescuetime::Errors::InvalidCredentialsError
      end
    end

    context 'query is badly formed' do
      it 'raises an InvalidQueryError'
    end

    context 'response status is 400' do
      it 'raises a BadRequestError'
    end

    context 'response status is 500' do
      it 'raises an InternalServerError'
    end
  end
end
