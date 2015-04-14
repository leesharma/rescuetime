module Rescuetime
  class Client
    attr_writer :api_key

    def initialize(opts={})
      @api_key = opts[:api_key]
    end

    def api_key?
      !!@api_key
    end
  end
end