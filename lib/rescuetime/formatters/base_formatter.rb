module Rescuetime::Formatters
  # Base class for report formatters
  #
  # @abstract Subclass and override {.name} and {.format} to implement a custom
  #           formatter
  # @see Rescuetime::Formatters::CSVFormatter
  # @see Rescuetime::Formatters::ArrayFormatter
  # @since v0.4.0
  class BaseFormatter
    # Returns the name of your formatter
    #
    # @return [String]  a name for your report formatter
    #
    # @raise  [NotImplementedError] this method is not yet implemented
    def self.name
      fail NotImplementedError, 'you have not defined a report name'
    end

    # Formats the rescuetime report from CSV to a user-defined format
    #
    # @param  [CSV] _report  a csv-formatted report
    # @return                a report formatted to your specifications
    #
    # @raise  [NotImplementedError] this method is not yet implemented
    def self.format(_report)
      fail NotImplementedError,
           'you have not defined report formatting instructions'
    end

    # Returns all classes descended from the current class
    #
    # @example
    #   require 'rescuetime/formatters/array_formatter'
    #   base_formatter = Rescuetime::Formatters::BaseFormatter
    #
    #   base_formatter.descendents
    #   #=> [Rescuetime::Formatters::ArrayFormatter]
    #
    # @return [Array<Class>]  all loaded descendents of the current class
    def self.descendents
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end
end
