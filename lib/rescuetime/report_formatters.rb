# frozen_string_literal: true

require 'rescuetime/formatters'

module Rescuetime
  # Represents the collection of report formatters. Autoloads all formatters
  # based on filename and file location.
  # @since v0.4.0
  class ReportFormatters
    include Rescuetime::Formatters

    # Returns or loads a memoized list of formatters
    #
    # @example
    #   report_formatters = Rescuetime::ReportFormatters.new.formatters
    #   #=> [Rescuetime::Formatters::ArrayFormatter,
    #   #    Rescuetime::Formatters::CSVFormatter]
    #
    # @return [Array<Class>]  list of available report formatters
    def formatters
      @formatters ||= load_formatters
    end

    # Force a reload of report formatters
    #
    # @example
    #   report_formatters = Rescuetime::ReportFormatters.new
    #   report_formatters.formatters
    #   #=> [Rescuetime::Formatters::ArrayFormatter,
    #   #    Rescuetime::Formatters::CSVFormatter]
    #
    #   Rescuetime.configure do |config|
    #     config.formatter_paths << 'local/formatters/html_formatter.rb'
    #   end
    #
    #   report_formatters.reload
    #   #=> [Rescuetime::Formatters::ArrayFormatter,
    #   #    Rescuetime::Formatters::CSVFormatter,
    #   #    Rescuetime::Formatters::HTMLFormatter]
    #
    #   report_formatters.formatters
    #   #=> [Rescuetime::Formatters::ArrayFormatter,
    #   #    Rescuetime::Formatters::CSVFormatter,
    #   #    Rescuetime::Formatters::HTMLFormatter]
    #
    # @return [Array<Class>]  list of available report formatters
    def reload
      @formatters = load_formatters
    end

    # Returns a list of available formatter names
    #
    # @example
    #   report_formatters = Rescuetime::ReportFormatters.new
    #   report_formatters.all
    #   #=> ["array", "csv"]
    #
    # @return [Array<String>]  a list of formatter names
    def all
      formatters.map(&:name)
    end

    # Returns the formatter with the specified name or, if not found, raises
    # an exception
    #
    # @param  [String] name  the name of the desired formatter
    # @return [Class]        the specified formatter
    #
    # @raise [Rescuetime::Errors::InvalidFormatError]
    def find(name)
      formatter = formatters.find do |f|
        standardize(f.name) == standardize(name)
      end
      formatter || raise(Rescuetime::Errors::InvalidFormatError)
    end

    private

    def standardize(str)
      str.to_s.downcase
    end
  end
end
