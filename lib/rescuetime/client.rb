require 'faraday'
require 'csv'

require 'rescuetime/reportable'
require 'rescuetime/http_requestable'

module Rescuetime
  # Rescuetime::Client makes HTTP requests to the RescueTime API and returns
  # the appropriate values
  #
  # @since v0.1.0
  class Client
    include Reportable
    include HTTPRequestable

    # Base URL for RescueTime Data Analytics API endpoint
    # @since v0.1.0
    BASE_HOST = 'https://www.rescuetime.com/anapi/data'

    # @!attribute [rw] api_key
    # @since v0.1.0
    attr_accessor :api_key

    # @since v0.1.0
    def initialize(options = {})
      @api_key    = options[:api_key]
      @query      = Query.new
      @connection = Faraday.new(BASE_HOST)
      @format     = :array
    end

    # @since v0.1.0
    def api_key?
      !!@api_key && !@api_key.empty?
    end

    # @since v0.2.0
    def valid_credentials?
      return false unless api_key?
      !!get rescue false
    end

    # @since v0.3.0
    def fetch
      response = parse_response(get.body)
      @query = Query.new
      response
    end

    private

    # @since v0.1.0
    def parse_response(body)
      activities = CSV.new(body,
                           headers: true,
                           header_converters: :symbol,
                           converters: :all)

      case @format
      when :array then activities.to_a.map(&:to_hash)
      when :csv   then activities
      else
        raise InvalidFormatError,
          "'#{@format.to_s}' is not a valid format. See documentation for valid options."
      end
    end
  end

  # @since v0.3.0
  Query = Struct.new(:restrict_kind, :perspective, :resolution_time,
                     :restrict_begin, :restrict_end,
                     :restrict_thing, :restrict_thingy)
end
