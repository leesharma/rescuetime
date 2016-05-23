require 'rescuetime/version'
require 'rescuetime/configuration'
require 'rescuetime/client'
require 'rescuetime/errors'

# Wrapper module for rescuetime gem
#
# @since v0.1.0
module Rescuetime
  # class << self
  #   attr_writer :configuration
  # end

  # Passes a block to the Rescuetime configuration, allowing configuration
  # options to be set.
  #
  # @example
  #   # In an initializer or before any report formatters are called:
  #   Rescuetime.configure do |config|
  #     config.formatter_paths += ['path/to/local/formatters/*_formatter.rb']
  #   end
  #
  #   # Let's say that directory contains the valid formatters pdf_formatter.rb
  #   # and json_formatter.rb
  #   report_formatters = Rescuetime::ReportFormatters.new
  #   puts report_formatters.all
  #   #=> ["array", "csv", "pdf", "json"]
  #
  # @see Rescuetime.configuration
  # @see Rescuetime::Configuration
  # @since v0.4.0
  def self.configure
    yield(configuration)
  end

  # Returns either the current configuration (if set) or initializes a new
  # default configuration.
  #
  # @example
  #   Rescuetime.configuration.formatter_paths
  #   #=> []
  #
  #   Rescuetime.configure do |config|
  #     config.formatter_paths += ['formatters/*.rb']
  #   end
  #   Rescuetime.configuration.formatter_paths
  #   #=> ["formatters/*.rb"]
  #
  # @see Rescuetime::Configuration
  # @return [Rescuetime::Configuration]  the current Rescuetime configuration
  # @since v0.4.0
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Resets the configuration back to the initial state. Mainly useful for
  # resetting the class after testing, making specs order-independent.
  #
  # @example
  #   before :each do
  #     Rescuetime.configure { |c| c.formatter_paths += ['formatters/*.rb'] }
  #   end
  #
  #   after :each do
  #     Rescuetime.reset
  #   end
  #
  # @see Rescuetime::Configuration#initialize
  # @since v0.4.0
  def self.reset
    @configuration = Configuration.new
  end
end
