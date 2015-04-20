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
    # @since v0.2.0
    def get(url, options={})
      Faraday.get url, options.
                         merge(DEFAULT_OPTIONS).
                         merge({key: @api_key})
    end
  end
end