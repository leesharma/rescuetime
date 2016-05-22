require 'rescuetime/query_buildable'

module Rescuetime
  # Represents a potential rescuetime collection. It holds the query information
  # and performs the query lazily, when #all or an Enumerable method is called.
  class Collection
    include QueryBuildable
    include Enumerable

    # Rescuetime Analytics API endpoint
    HOST = 'https://www.rescuetime.com/anapi/data'

    # Returns a new Rescuetime collection. Default format is array.
    #
    # @param  [Array<Hash>]            terms  a list of parameter hashes
    # @return [Rescuetime::Collection]        a new Rescuetime collection
    def initialize(*terms)
      @params = terms.reduce({}, :merge)
      @format = :array
    end

    # Appends new terms onto the Rescuetime collection. In the case of duplicate
    # keys, the later keys overwrite the former keys.
    #
    # @param  [Hash] terms  new terms to add to collection params
    # @return [Hash]        collection params with terms merged in
    def <<(terms)
      @params = params.merge terms
    end

    # Performs the rescuetime query and returns an array or csv response.
    #
    # @return [Array, CSV]
    #
    # @see Rescuetime::Requester#get
    def all
      parse_response Requester.get(HOST, params).body
    end

    # Enumerates over the collection of Rescuetime report records. Performs
    # the query.
    #
    # @return [Array, CSV]
    #
    # @see #all
    # @see http://ruby-doc.org/core/Enumerable.html Enumerable
    def each(&block)
      all.each &block
    end

    # @param  [#to_s] format  desired report format (one of 'array' or 'csv')
    # @return [Rescuetime::Collection]
    #
    # @todo: make chainable to the client
    def format(format)
      format = format.to_s
      fail InvalidFormatError unless %w(array csv).include? format

      @format = format
      self
    end

    private

    # Stores the query parameters to be set to the rescuetime host
    attr_reader :params

    # @param [String] body response body
    # @return [Array, CSV]
    def parse_response(body)
      report = CSV.new(body,
                       headers: true,
                       header_converters: :symbol,
                       converters: :all)

      case @format.intern
      when :array then report.to_a.map(&:to_hash)
      when :csv   then report
      else
        fail InvalidFormatError
      end
    end
  end
end
