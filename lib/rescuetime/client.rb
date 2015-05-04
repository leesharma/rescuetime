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

    # @!attribute [rw] api_key
    attr_accessor :api_key

    # @return [Resucetime::Client]
    def initialize(key = nil, **opts)
      @api_key    = key || opts[:api_key]
    end

    # @return [Boolean]
    def api_key?
      !!@api_key && !@api_key.empty?
    end

    # @return [Boolean]
    def valid_credentials?
      return false unless api_key?
      !!activities.all rescue false
    end

    private

    # @return [Hash]
    def state
      { key: @api_key }
    end
  end
end
