# frozen_string_literal: true

module PaypalAPI
  #
  # Common interface for all errors
  #
  class Error < StandardError
    # @return [Response, nil] Returned response with non-200 status code
    attr_reader :response

    # @return [Request] Sent request
    attr_reader :request

    # @return [String] Error name provided by PayPal or Net::HTTP network error name
    attr_reader :error_name

    # @return [String] Error message provided by PayPal or Net::HTTP network error message
    attr_reader :error_message

    # @return [String, nil] Error debug_id returned by PayPal
    attr_reader :error_debug_id

    # @see https://developer.paypal.com/api/rest/responses/#link-examples
    # @return [Array, nil] Error details returned by PayPal
    attr_reader :error_details

    # @return [String, nil] PayPal-Request-Id header assigned to request
    attr_reader :paypal_request_id
  end

  #
  # Namespace for specific PaypalAPI errors
  #
  module Errors
    #
    # Raised when PayPal responds with any status code except 200, 201, 202, 204
    #
    class FailedRequest < Error
      def initialize(message = nil, request:, response:)
        @request = request
        @response = response

        body = response.body
        data = body.is_a?(Hash) ? body : {}
        @error_name = data[:name] || data[:error] || response.http_response.class.name
        @error_message = data[:message] || data[:error_description] || response.http_body.to_s
        @error_debug_id = data[:debug_id]
        @error_details = data[:details]
        @paypal_request_id = request.http_request["paypal-request-id"]

        message += "\n  #{response.http_body}" unless data.empty?
        super(message)
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
        @paypal_request_id = request.http_request["paypal-request-id"]
      end
    end

    # 400
    class BadRequest < FailedRequest
    end

    # 401
    class Unauthorized < FailedRequest
    end

    # 403
    class Forbidden < FailedRequest
    end

    # 404
    class NotFound < FailedRequest
    end

    # 405
    class MethodNotAllowed < FailedRequest
    end

    # 406
    class NotAcceptable < FailedRequest
    end

    # 409
    class Conflict < FailedRequest
    end

    # 415
    class UnsupportedMediaType < FailedRequest
    end

    # 422
    class UnprocessableEntity < FailedRequest
    end

    # 429
    class TooManyRequests < FailedRequest
    end

    # 5xx
    class FatalError < FailedRequest
    end

    # 500
    class InternalServerError < FatalError
    end

    # 503
    class ServiceUnavailable < FatalError
    end
  end
end
