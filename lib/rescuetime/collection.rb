# frozen_string_literal: true

require 'csv'

require 'rescuetime/query_buildable'
require 'rescuetime/report_formatters'

module Rescuetime
  # Represents a potential rescuetime collection. It holds the query information
  # and performs the query lazily, when #all or an Enumerable method is called.
  class Collection
    include QueryBuildable
    include Enumerable

    # Rescuetime Analytics API endpoint
    HOST = 'https://www.rescuetime.com/anapi/data'.freeze

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
      requester = Rescuetime::Requester
      host      = HOST
      parse_response requester.get(host, params)
    end

    # Enumerates over the collection of Rescuetime report records. Performs
    # the query.
    #
    # @return [Array, CSV]
    #
    # @see #all
    # @see http://ruby-doc.org/core/Enumerable.html Enumerable
    def each(&block)
      all.each(&block)
    end

    # Sets the report format to a valid type
    #
    # @param  [#to_s] format  desired report format (one of 'array' or 'csv')
    # @return [Rescuetime::Collection]
    #
    # TODO: make chainable to the client
    def format(format)
      # Guard: fail if the passed format isn't on the whitelist
      format = format.to_s
      formatters.all.include?(format) || raise(Errors::InvalidFormatError)

      @format = format
      self
    end

    private

    # Stores the query parameters to be set to the rescuetime host
    attr_reader :params

    # Returns a new collection of available report formatters (using the
    # Rescuetime::ReportFormatters class)
    #
    # @param  [Class] formatter_collection  defaults to
    #                                       Rescuetime::ReportFormatters
    # @return [Rescuetime::ReportFormatter]
    # @since v0.4.0
    def formatters(formatter_collection: Rescuetime::ReportFormatters)
      @formatters ||= formatter_collection.new
    end

    # Parses a response from the string response body to the desired format.
    #
    # @param [String] body response body
    # @return [Array, CSV]
    def parse_response(body)
      report = CSV.new(body,
                       headers: true,
                       header_converters: :symbol,
                       converters: :all)

      format           = @format.to_s.downcase
      report_formatter = formatters.find(format)

      report_formatter.format report
    end
  end
end
