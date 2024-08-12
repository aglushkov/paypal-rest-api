# frozen_string_literal: true

require "net/http"

module PaypalAPI
  #
  # Builds PaypalAPI::FailedRequest error
  #
  class FailedRequestErrorBuilder
    # Matchings for Net::HTTP response class to PaypalAPI::Error class
    RESPONSE_ERROR_MAP = {
      Net::HTTPBadRequest => Errors::BadRequest,                     # 400
      Net::HTTPUnauthorized => Errors::Unauthorized,                 # 401
      Net::HTTPForbidden => Errors::Forbidden,                       # 403
      Net::HTTPNotFound => Errors::NotFound,                         # 404
      Net::HTTPMethodNotAllowed => Errors::MethodNotAllowed,         # 405
      Net::HTTPNotAcceptable => Errors::NotAcceptable,               # 406
      Net::HTTPConflict => Errors::Conflict,                         # 409
      Net::HTTPUnsupportedMediaType => Errors::UnsupportedMediaType, # 415
      Net::HTTPUnprocessableEntity => Errors::UnprocessableEntity,   # 422
      Net::HTTPTooManyRequests => Errors::TooManyRequests,           # 429
      Net::HTTPInternalServerError => Errors::InternalServerError,   # 500
      Net::HTTPServiceUnavailable => Errors::ServiceUnavailable      # 503
    }.freeze

    class << self
      # Builds FailedRequestError instance
      #
      # @param request [Request] Original request
      # @param response [Response] Original response
      #
      # @return [Errors::FailedRequestError] error object
      #
      def call(request:, response:)
        http_response = response.http_response
        error_message = "#{http_response.code} #{http_response.message}"
        error_class = RESPONSE_ERROR_MAP.fetch(http_response.class, Errors::FailedRequest)
        error_class.new(error_message, response: response, request: request)
      end
    end
  end
end
