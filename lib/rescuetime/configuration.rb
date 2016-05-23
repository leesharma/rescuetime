module Rescuetime
  # Represents a set of Rescuetime configuration settings
  #
  # @since v0.4.0
  class Configuration
    # Contains user-specified formatter paths. Defaults to [] when a new
    # configuration is created.
    #
    # @see Rescuetime.configure
    attr_accessor :formatter_paths

    # Creates a new Rescuetime configuration, defaulting to no formatter paths
    #
    # @return [Rescuetime::Configuration]  a new rescuetime configuration
    # @see Rescuetime.configure
    def initialize
      @formatter_paths = []
    end
  end
end
