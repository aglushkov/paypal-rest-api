# frozen_string_literal: true

require "net/http"

module PaypalAPI
  #
  # Builds PaypalAPI::FailedRequest error
  #
  class FailedRequestErrorBuilder
    # Matchings for Net::HTTP response class to PaypalAPI::Error class
    RESPONSE_ERROR_MAP = {
      Net::HTTPBadRequest => BadRequestError,                     # 400
      Net::HTTPUnauthorized => UnauthorizedError,                 # 401
      Net::HTTPForbidden => ForbiddenError,                       # 403
      Net::HTTPNotFound => NotFoundError,                         # 404
      Net::HTTPMethodNotAllowed => MethodNotAllowedError,         # 405
      Net::HTTPNotAcceptable => NotAcceptableError,               # 406
      Net::HTTPConflict => ConflictError,                         # 409
      Net::HTTPUnsupportedMediaType => UnsupportedMediaTypeError, # 415
      Net::HTTPUnprocessableEntity => UnprocessableEntityError,   # 422
      Net::HTTPTooManyRequests => TooManyRequestsError,           # 429
      Net::HTTPInternalServerError => InternalServerError,        # 500
      Net::HTTPServiceUnavailable => ServiceUnavailableError      # 503
    }.freeze

    class << self
      # Builds FailedRequestError instance
      #
      # @param request [Request] Original request
      # @param response [Response] Original response
      #
      # @return [FailedRequestError] Built FailedRequestError
      #
      def call(request:, response:)
        http_response = response.http_response
        error_message = "#{http_response.code} #{http_response.message}"
        error_class = RESPONSE_ERROR_MAP.fetch(http_response.class, FailedRequest)
        error_class.new(error_message, response: response, request: request)
      end
    end
  end
end
