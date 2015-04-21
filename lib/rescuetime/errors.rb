module Rescuetime
  # Error class for rescuing all RescueTime errors
  class Error < StandardError; end

  # Raised when a method requires credentials but none are provided
  class MissingCredentials < Error; end

  # Raised when a method requires credentials but provided credentials are invalid
  class InvalidCredentials < Error; end
end