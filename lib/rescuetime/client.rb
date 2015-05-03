require 'faraday'
require 'csv'

require 'rescuetime/reportable'

module Rescuetime
  # Rescuetime::Client makes HTTP requests to the RescueTime API and returns
  # the appropriate values
  #
  # @since v0.1.0
  class Client
    include Reportable

    # Default options passed in any request
    # @since v0.2.0
    DEFAULT_OPTIONS = { format: 'csv', version: 0, operation: 'select' }

    # @!attribute [rw] api_key
    # @since v0.1.0
    attr_accessor :api_key

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
    def initialize(options = {})
      @api_key = options[:api_key]
    end

    # Checks whether an api key is set
    #
    # @return [Boolean]
    # @since v0.1.0
    def api_key?
      !!@api_key && !@api_key.empty?
    end

    # Checks whether client credentials are valid. If credentials are present, this
    # action involves an HTTP request.
    #
    # @example Three cases of checking credentials (missing, invalid, and valid)
    #   @client = Rescuetime::Client.new
    #   @client.valid_credentials?        # => false
    #
    #   # Note: The following scenarios involve an HTTP request.
    #   @client.api_key = 'Invalid Key'
    #   @client.valid_credentials?        # => false
    #
    #   @client.api_key = VALID_API_KEY
    #   @client.valid_credentials?        # => true
    #
    # @return [Boolean]
    # @since v0.2.0
    def valid_credentials?
      return false unless api_key?
      !!activities rescue false
    end

    protected

    # Performs an HTTP get request
    #
    # @param [String] url request url
    # @param [Hash] options query params for request
    #
    # @raise [Rescuetime::MissingCredentials] if the Rescuetime::Client has no
    #   set api key
    # @raise [Rescuetime::InvalidCredentials] if the provided api key is
    #   rejected by RescueTime
    # @since v0.2.0
    def get(url, options = {})
      fail Rescuetime::MissingCredentials unless api_key?
      response = Faraday.get(url, query_params(options)
                                  .merge(DEFAULT_OPTIONS)
                                  .merge(key: @api_key))

      invalid_credentials_body = '{"error":"# key not found","messages":"key not found"}'
      fail Rescuetime::InvalidCredentials if
        response.body == invalid_credentials_body

      response
    end

    # Takes client request options hash and returns correct key/value pairs
    # for HTTP request
    #
    # @param [Hash] options options hash of client request
    # @return [Hash]
    # @since v0.2.0
    def query_params(options)
      params = {}
      params_mapping = { detail:    :restrict_kind,
                         by:        :perspective,
                         interval:  :resolution_time }

      params_mapping.each do |local, server|
        params[server] = options[local] if options[local]
      end

      # Special Cases
      params[:perspective] = 'interval' if params[:perspective] == 'time'
      if options[:date]
        params[:restrict_begin] = date_string options[:date]
        params[:restrict_end] = params[:restrict_begin]
      end
      if options[:from]
        params[:restrict_begin] = date_string options[:from]
        params[:restrict_end] = date_string(options[:to] || Time.now)
      end
      params
    end

    # Takes a date in either "YYYY-MM-DD" format or as a Time object and
    # returns a date string in "YYYY-MM-DD" format
    #
    # @return [String]
    def date_string(date)
      return date if date.is_a? String
      date.strftime('%Y-%m-%d')
    end
  end
end
