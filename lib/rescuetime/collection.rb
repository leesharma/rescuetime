require 'rescuetime/query_buildable'

module Rescuetime
  class Collection
    include QueryBuildable
    include Enumerable

    # attr_accessor :format
    # attr_reader :format

    HOST = 'https://www.rescuetime.com/anapi/data'

    def initialize(*terms)
      @params = terms.reduce({}, :merge)
      @format = :array
    end

    def <<(terms)
      @params.merge! terms
    end

    def all
      parse_response Requester.get(HOST, @params).body
    end

    def each(&block)
      all.each &block
    end

    # TODO: Chainable to client
    def format(format)
      @format = format
      self
    end

    private

    # @since v0.1.0
    def parse_response(body)
      report = CSV.new(body,
                           headers: true,
                           header_converters: :symbol,
                           converters: :all)

      case @format
        when :array then report.to_a.map(&:to_hash)
        when :csv   then report
        else
          raise InvalidFormatError,
                "'#{@format.to_s}' is not a valid format. See documentation for valid options."
      end
    end
  end
end