module Rescuetime::Formatters
  # Formats a rescuetime report as a CSV object
  #
  # @since v0.4.0
  class CSVFormatter < BaseFormatter
    # Returns the name of your formatter
    #
    # @return [String]  a name for your report formatter ("csv")
    def self.name
      'csv'
    end

    # Returns the rescuetime report in raw form
    #
    # @param  [CSV]  report  a csv-formatted report
    # @return [CSV]          a csv-formatted report
    def self.format(report)
      report
    end
  end
end
