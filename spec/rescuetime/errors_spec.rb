require 'spec_helper'

describe 'Error handling' do
  describe Rescuetime::MissingCredentials do
    it 'is raised when no credentials are provided' do
      invalid_client = Rescuetime::Client.new
      expect{invalid_client.activities}.to raise_error(Rescuetime::MissingCredentials)
    end
  end

  describe Rescuetime::InvalidCredentials do
    it 'is raised when credentials are invalid' do
      VCR.use_cassette('invalid credentials',
                       match_requests_on: [:host, :path], record: :none) do
        invalid_client = Rescuetime::Client.new(api_key: 'AK')
        expect{invalid_client.activities}.to raise_error(Rescuetime::InvalidCredentials)
      end
    end
  end
end