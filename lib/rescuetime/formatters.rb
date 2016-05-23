require 'rescuetime/formatters/base_formatter'

module Rescuetime
  # Contains all Rescuetime formatters and formatter-loading behavior
  # @since v0.4.0
  module Formatters
    # The superclass for all valid Rescuetime formatters
    BASE_FORMATTER       = Rescuetime::Formatters::BaseFormatter
    # The path where local in-gem formatters are stored. Expands to
    # lib/rescuetime/formatters/*_formatter.rb
    LOCAL_FORMATTER_PATH = '../formatters/*_formatter.rb'

    # Returns a list of known formatters. A known formatter is either in the
    # local gem folder lib/rescuetime/formatters/ and ends in '_formatter.rb',
    # or it follows the path-matching options provided by the user using
    # Rescuetime.configure.
    #
    # @param  [Class#descendents] base_formatter  the formatter superclass -
    #                                             #load_formatters returns all
    #                                             classes that inherit from this
    #                                             class
    # @return [Array<Class>]                      known report formatters
    #
    # @see Rescuetime::Configuration.formatter_paths
    def load_formatters(base_formatter: BASE_FORMATTER)
      load_formatter_files
      base_formatter.descendents
    end

    private

    # Requires all formatter files, determined by the local path for formatters
    # plus any additional paths set in the Rescuetime configuration.
    #
    # @param  [String] local_path  the location of the local in-gem formatters
    #
    # @see Rescuetime::Configuration.formatter_paths
    def load_formatter_files(local_path: LOCAL_FORMATTER_PATH)
      # require all formatters, local and configured
      paths = Rescuetime.configuration.formatter_paths << local_path
      paths.each do |path|
        Dir[File.expand_path(path, __FILE__)].each { |file| require file }
      end
    end
  end
end
