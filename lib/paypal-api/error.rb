# frozen_string_literal: true

module PaypalAPI
  #
  # Common interface for all errors
  #
  class Error < StandardError
    attr_reader :response, :request, :error_name, :error_message, :error_debug_id, :error_details
  end

  #
  # Raised when PayPal responds with any status code except 200, 201, 202, 204
  #
  class FailedRequest < Error
    def initialize(message = nil, request:, response:)
      super(message)
      @request = request
      @response = response

      body = response.body
      data = body.is_a?(Hash) ? body : {}
      @error_name = data[:name] || data[:error] || response.http_response.class.name
      @error_message = data[:message] || data[:error_description] || response.http_body.to_s
      @error_debug_id = data[:debug_id]
      @error_details = data[:details]
    end
  end

  #
  # Raised when a network raised when executing the request
  # List of network errors can be found in errors/network_error_builder.rb
  #
  class NetworkError < Error
    def initialize(message = nil, request:, error:)
      super(message)
      @request = request
      @response = nil
      @error_name = error.class.name
      @error_message = error.message
      @error_debug_id = nil
      @error_details = nil
    end
  end

  # 400
  class BadRequestError < FailedRequest
  end

  # 401
  class UnauthorizedError < FailedRequest
  end

  # 403
  class ForbiddenError < FailedRequest
  end

  # 404
  class NotFoundError < FailedRequest
  end

  # 405
  class MethodNotAllowedError < FailedRequest
  end

  # 406
  class NotAcceptableError < FailedRequest
  end

  # 409
  class ConflictError < FailedRequest
  end

  # 415
  class UnsupportedMediaTypeError < FailedRequest
  end

  # 422
  class UnprocessableEntityError < FailedRequest
  end

  # 429
  class TooManyRequestsError < FailedRequest
  end

  # 5xx
  class FatalError < FailedRequest
  end

  # 500
  class InternalServerError < FatalError
  end

  # 503
  class ServiceUnavailableError < FatalError
  end
end
