module Rescuetime::Formatters
  # Formats a rescuetime report as an array of hashes.
  #
  # @since v0.4.0
  class ArrayFormatter < BaseFormatter
    # Returns the name of your formatter
    #
    # @return [String]  a name for your report formatter ("array")
    def self.name
      'array'
    end

    # Formats the rescuetime report from CSV to a user-defined format
    #
    # @param  [#to_a]       report  a csv-formatted report
    # @return [Array<Hash>]         a report formatted as an array of hashes
    def self.format(report)
      report.to_a.map(&:to_hash)
    end
  end
end
