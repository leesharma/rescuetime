require 'spec_helper'

describe 'Error handling' do
  let(:client) { Rescuetime::Client.new(api_key: 'AK') }
  describe 'for HTTP response status' do
    describe Rescuetime::BadRequest do
      it 'is returned for response status 400' do
        stub_request(:get, /.*rescuetime.*/).to_return(status: 400)
        expect { client.overview.fetch }
          .to raise_error(Rescuetime::BadRequest)
      end
    end
    describe Rescuetime::Unauthorized do
      it 'is returned for response status 401' do
        stub_request(:get, /.*rescuetime.*/).to_return(status: 401)
        expect { client.overview.fetch }
          .to raise_error(Rescuetime::Unauthorized)
      end
    end
    describe Rescuetime::Forbidden do
      it 'is returned for response status 403' do
        stub_request(:get, /.*rescuetime.*/).to_return(status: 403)
        expect { client.overview.fetch }
          .to raise_error(Rescuetime::Forbidden)
      end
    end
    describe Rescuetime::NotFound do
      it 'is returned for response status 404' do
        stub_request(:get, /.*rescuetime.*/).to_return(status: 404)
        expect { client.overview.fetch }
          .to raise_error(Rescuetime::NotFound)
      end
    end
    describe Rescuetime::NotAcceptable do
      it 'is returned for response status 406' do
        stub_request(:get, /.*rescuetime.*/).to_return(status: 406)
        expect { client.overview.fetch }
          .to raise_error(Rescuetime::NotAcceptable)
      end
    end
    describe Rescuetime::UnprocessableEntity do
      it 'is returned for response status 422' do
        stub_request(:get, /.*rescuetime.*/).to_return(status: 422)
        expect { client.overview.fetch }
          .to raise_error(Rescuetime::UnprocessableEntity)
      end
    end

    describe Rescuetime::InternalServerError do
      it 'is returned for response status 500' do
        stub_request(:get, /.*rescuetime.*/).to_return(status: 500)
        expect { client.overview.fetch }
          .to raise_error(Rescuetime::InternalServerError)
      end
    end
    describe Rescuetime::NotImplemented do
      it 'is returned for response status 501' do
        stub_request(:get, /.*rescuetime.*/).to_return(status: 501)
        expect { client.overview.fetch }
          .to raise_error(Rescuetime::NotImplemented)
      end
    end
    describe Rescuetime::BadGateway do
      it 'is returned for response status 502' do
        stub_request(:get, /.*rescuetime.*/).to_return(status: 502)
        expect { client.overview.fetch }
          .to raise_error(Rescuetime::BadGateway)
      end
    end
    describe Rescuetime::ServiceUnavailable do
      it 'is returned for response status 503' do
        stub_request(:get, /.*rescuetime.*/).to_return(status: 503)
        expect { client.overview.fetch }
          .to raise_error(Rescuetime::ServiceUnavailable)
      end
    end
  end

  # Internal Errors

  describe Rescuetime::MissingCredentialsError do
    subject(:invalid_client) { Rescuetime::Client.new }
    it 'is raised when no credentials are provided' do
      expect { invalid_client.activities.fetch }
        .to raise_error(Rescuetime::MissingCredentialsError)
    end
  end

  describe Rescuetime::InvalidCredentialsError do
    subject(:invalid_client) { Rescuetime::Client.new(api_key: 'invalid_key') }
    it 'is raised when credentials are invalid' do
      VCR.use_cassette('analytic data responses (no dates)') do
        expect { invalid_client.activities.fetch }
          .to raise_error(Rescuetime::InvalidCredentialsError)
      end
    end
  end

  describe Rescuetime::InvalidQueryError do
    subject { client }
    it 'is raised when an invalid query value is submitted' do
      VCR.use_cassette('analytic data responses (no dates)') do
        expect { subject.overview.order_by(:invalid).fetch }
          .to raise_error(Rescuetime::InvalidQueryError)
      end
    end
    it 'is raised when a query error is recieved from the server' do
      error_response = '{"error": "# query error","messages": "Error: Likely a badly formatted or missing parameter"}'
      stub_request(:get, /.*rescuetime.*/)
        .with(query: hash_including({}))
        .to_return(body: error_response, status: 200)

      expect { subject.overview.where(name: 'Invalid Name').fetch }
        .to raise_error(Rescuetime::InvalidQueryError)
    end
  end

  describe Rescuetime::InvalidFormatError do
    subject { client }
    it 'is raised when an invalid format is specified' do
      VCR.use_cassette('analytic data responses (no dates)') do
        expect { subject.overview.format(:invalid).fetch }
          .to raise_error(Rescuetime::InvalidFormatError)
      end
    end
  end
end
