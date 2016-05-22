require 'faraday'
require 'csv'

require 'rescuetime/query_buildable'

require 'rescuetime/requester'
require 'rescuetime/collection'

module Rescuetime
  # Rescuetime::Client makes HTTP requests to the RescueTime API and returns
  # the appropriate values
  #
  # @since v0.1.0
  class Client
    include QueryBuildable

    # Represents the client's Rescuetime API key, required for successful
    # requests
    #
    # @return [String, nil]    Rescuetime API key
    attr_accessor :api_key

    # Creates a new Rescuetime client. The API key can be passed as either a
    # parameter or option (with "key" taking priority over ":api_key")
    #
    # @example Basic Use
    #   Rescuetime::Client.new
    #   # => #<Rescuetime::Client:0x007f938489b6c8 @api_key=nil>
    #
    # @example Setting the API Key
    #   Rescuetime::Client.new
    #   # => #<Rescuetime::Client:0x007f938489b6c8 @api_key=nil>
    #
    #   Rescuetime::Client.new('12345')
    #   # => #<Rescuetime::Client:0x007f938489b6c8 @api_key="12345">
    #
    #   Rescuetime::Client.new(api_key: 12345')
    #   # => #<Rescuetime::Client:0x007f938489b6c8 @api_key="12345">
    #
    #   Rescuetime::Client.new('123', api_key: '456')
    #   # => #<Rescuetime::Client:0x007f938489b6c8 @api_key="123">
    #
    # @param  [String, nil] key      API key
    # @param  [String]      api_key  Rescuetime API key
    # @return [Rescuetime::Client]
    def initialize(key = nil, api_key: nil)
      @api_key = key || api_key
    end

    # Returns true if the API key is present.
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.api_key?
    #   # => false
    #
    #   client.api_key = ''
    #   client.api_key?
    #   # => false
    #
    #   client.api_key = '12345'
    #   client.api_key?
    #   # => true
    #
    # @return [Boolean]
    def api_key?
      present? api_key
    end

    # Returns true if the provided api key is valid. Performs a request to the
    # Rescuetime API.
    #
    # @example Basic Use
    #   # Assuming that INVALID_KEY is an invalid Rescuetime API key
    #   # and VALID_KEY is a valid one
    #
    #   client = Rescuetime::Client
    #   client.valid_credentials?
    #   # => false
    #
    #   client.api_key = INVALID_KEY
    #   client.valid_credentials? # Performs a request to the Rescuetime API
    #   # => false
    #
    #   client.api_key = VALID_KEY
    #   client.valid_credentials? # Performs a request to the Rescuetime API
    #   # => true
    #
    # @return [Boolean]
    def valid_credentials?
      return false unless api_key?
      !activities.all.nil?
    rescue Rescuetime::InvalidCredentialsError
      false
    end

    private

    # Returns true if the project is present and non-blank
    #
    # @param  [#emtpy?] obj
    # @return [Boolean]
    # @since  v0.3.2
    def present?(obj)
      blank = obj.respond_to?(:empty?) ? obj.empty? : obj.nil?
      !blank
    end

    # @return [Hash]
    def state
      { key: api_key }
    end
  end
end
