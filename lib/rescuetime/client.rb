require 'rescuetime/api'

module Rescuetime
  class Client
    include Rescuetime::Api

    attr_writer :api_key

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Rescuetime::Client]
    def initialize(options={})
      @api_key = options[:api_key]
    end

    # Checks whether an api key is set
    #
    # @return [Boolean]
    def api_key?
      !!@api_key
    end
  end
end