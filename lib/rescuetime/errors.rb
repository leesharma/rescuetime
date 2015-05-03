module Rescuetime
  # Error class for rescuing all RescueTime errors
  class Error < StandardError
  end

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
  class CredentialsError < Error; end
  # Raised when a method requires credentials but none are provided
  class MissingCredentialsError < CredentialsError; end

  # Raised when a method requires credentials but credentials are invalid
  class InvalidCredentialsError < CredentialsError; end

  # Raised when a user-submitted query value is invalid
  class InvalidQueryError < Error; end

  # Raised when a user-submitted query value is invalid
  class InvalidFormatError < Error; end

  class Error
    HTTP_ERRORS = {
      400 => Rescuetime::BadRequest,
      401 => Rescuetime::Unauthorized,
      403 => Rescuetime::Forbidden,
      404 => Rescuetime::NotFound,
      406 => Rescuetime::NotAcceptable,
      422 => Rescuetime::UnprocessableEntity,
      429 => Rescuetime::TooManyRequests,
      500 => Rescuetime::InternalServerError,
      501 => Rescuetime::NotImplemented,
      502 => Rescuetime::BadGateway,
      503 => Rescuetime::ServiceUnavailable,
      504 => Rescuetime::GatewayTimeout,
    }
  end
end
