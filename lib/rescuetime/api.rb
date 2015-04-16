require 'rescuetime/activities'

module Rescuetime
  # The Rescuetime::API module includes all modules corresponding to RescueTime
  # API endpoints.
  #
  # For more information on the RescueTime Client, see #Rescuetime::Client.
  # For more information on included methods, see method summary below.
  # @since v0.1.0
  module Api
    include Rescuetime::Activities
  end
end