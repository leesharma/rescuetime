require 'rescuetime/query_buildable'

module Rescuetime
  class Collection
    include QueryBuildable
    include Enumerable

    HOST = 'https://www.rescuetime.com/anapi/data'

    # @return [Rescuetime::Collection]
    def initialize(*terms)
      @params = terms.reduce({}, :merge)
      @format = :array
    end

    # @return [Hash]
    def <<(terms)
      @params.merge! terms
    end

    # @return [Array, CSV]
    def all
      parse_response Requester.get(HOST, @params).body
    end

    def each(&block)
      all.each &block
    end

    # TODO: Chainable to client
    # @return [Rescuetime::Collection]
    def format(format)
      fail InvalidFormatError unless %w(array csv).include? format.to_s
      @format = format.to_sym
      self
    end

    private

    # @param [String] body response body
    # @return [Array, CSV]
    def parse_response(body)
      report = CSV.new(body,
                       headers: true,
                       header_converters: :symbol,
                       converters: :all)

      case @format
      when :array then report.to_a.map(&:to_hash)
      when :csv   then report
      else
        fail InvalidFormatError
      end
    end
  end
end
