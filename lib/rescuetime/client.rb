require 'faraday'
require 'csv'

require 'rescuetime/api'

module Rescuetime
  # Rescuetime::Client makes HTTP requests to the RescueTime API and returns
  # the appropriate values
  #
  # @since v0.1.0
  class Client
    include Rescuetime::Api

    # Default options passed in any request
    # @since v0.2.0
    DEFAULT_OPTIONS = {format: 'csv', version: 0, operation: 'select' }

    # Overwrites the set RescueTime API key
    #
    # @!attribute [w] api_key
    # @since v0.1.0
    attr_writer :api_key

    # Initializes a new Client object
    #
    # @example
    #   @client = Rescuetime::Client.new  # options must be set before requests can be made
    # @example
    #   @client = Rescuetime::Client.new(api_key: '1234567890abcdefg')
    #
    # @param [Hash] options hash of RescueTime client options
    # @option options [String] :api_key RescueTime API key
    # @return [Rescuetime::Client]
    # @since v0.1.0
    def initialize(options={})
      @api_key = options[:api_key]
    end

    # Checks whether an api key is set
    #
    # @return [Boolean]
    # @since v0.1.0
    def api_key?
      !!@api_key
    end

    protected

    # Performs an HTTP get request
    #
    # @param [String] url request url
    # @param [Hash] options query params for request
    #
    # @raise [Rescuetime::MissingCredentials] if the Rescuetime::Client has no set api key
    # @raise [Rescuetime::InvalidCredentials] if the provided api key is rejected by RescueTime
    # @since v0.2.0
    def get(url, options={})
      raise Rescuetime::MissingCredentials unless api_key?
      response = Faraday.get url, query_params(options).
                                    merge(DEFAULT_OPTIONS).
                                    merge({key: @api_key})

      invalid_credentials_body = '{"error":"# key not found","messages":"key not found"}'
      raise Rescuetime::InvalidCredentials if response.body == invalid_credentials_body

      response
    end

    # Takes client request options hash and returns correct key/value pairs for HTTP request
    #
    # @param [Hash] options options hash of client request
    # @return [Hash]
    # @since v0.2.0
    def query_params(options)
      params = {}
      params_mapping = { detail: :restrict_kind, by: :perspective }

      params_mapping.each do |local, server|
        params[server] = options[local] if options[local]
      end

      params[:perspective] = 'interval' if params[:perspective] == 'time'
      params
    end
  end
end