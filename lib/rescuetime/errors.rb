# frozen_string_literal: true

module Rescuetime
  # Contains all Rescuetime error classes
  module Errors
    # Error class for rescuing all RescueTime errors
    class Error < StandardError; end

    ##
    # HTTP Errors
    # ===========
    # 4xx HTTP status code
    class ClientError < Error; end
    # HTTP status code 400
    class BadRequest < ClientError; end
    # HTTP status code 401
    class Unauthorized < ClientError; end
    # HTTP status code 403
    class Forbidden < ClientError; end
    # HTTP status code 404
    class NotFound < ClientError; end
    # HTTP status code 406
    class NotAcceptable < ClientError; end
    # HTTP status code 422
    class UnprocessableEntity < ClientError; end
    # HTTP status code 429
    class TooManyRequests < ClientError; end

    # 5xx HTTP status code
    class ServerError < Error; end
    # HTTP status code 500
    class InternalServerError < ServerError; end
    # HTTP status code 501
    class NotImplemented < ServerError; end
    # HTTP status code 502
    class BadGateway < ServerError; end
    # HTTP status code 503
    class ServiceUnavailable < ServerError; end
    # HTTP status code 504
    class GatewayTimeout < ServerError; end

    ##
    # Custom Errors
    # =============

    # Raised when a method requires credentials but none are provided
    class MissingCredentialsError < Unauthorized
      def initialize(msg = 'No API key provided. Please provide a valid key.')
        super
      end
    end

    # Raised when a method requires credentials but credentials are invalid
    class InvalidCredentialsError < Unauthorized
      def initialize(msg = 'API key is invalid. Please provide a valid key.')
        super
      end
    end

    # Raised when a user-submitted query value is invalid
    class InvalidQueryError < BadRequest
      def initialize(msg = 'Likely a badly formatted or missing parameter')
        super
      end
    end

    # Raised when a user-submitted query value is invalid
    class InvalidFormatError < Error
      def initialize(msg = 'Invalid format. Please see docs for allowed formats.')
        super
      end
    end

    # Error class for rescuing all RescueTime errors
    class Error
      # Collection of possible return status codes and corresponding Rescuetime
      # errors
      CODES = {
        400 => Rescuetime::Errors::BadRequest,
        401 => Rescuetime::Errors::Unauthorized,
        403 => Rescuetime::Errors::Forbidden,
        404 => Rescuetime::Errors::NotFound,
        406 => Rescuetime::Errors::NotAcceptable,
        422 => Rescuetime::Errors::UnprocessableEntity,
        429 => Rescuetime::Errors::TooManyRequests,
        500 => Rescuetime::Errors::InternalServerError,
        501 => Rescuetime::Errors::NotImplemented,
        502 => Rescuetime::Errors::BadGateway,
        503 => Rescuetime::Errors::ServiceUnavailable,
        504 => Rescuetime::Errors::GatewayTimeout
      }.freeze
    end
  end
end
