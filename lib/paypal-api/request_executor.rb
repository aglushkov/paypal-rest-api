# frozen_string_literal: true

module PaypalAPI
  #
  # Executes PaypalAPI::Request and returns PaypalAPI::Response or raises PaypalAPI::Error
  #
  class RequestExecutor
    RETRYABLE_RESPONSES = [
      Net::HTTPServerError,    # 5xx
      Net::HTTPConflict,       # 409
      Net::HTTPTooManyRequests # 429
    ].freeze

    class << self
      def call(request)
        http_response = execute(request)
        response = Response.new(http_response, requested_at: request.requested_at)
        raise FailedRequestErrorBuilder.call(request: request, response: response) unless http_response.is_a?(Net::HTTPSuccess)

        response
      end

      private

      def execute(request, retry_number: 0)
        http_response = execute_http_request(request)
      rescue *NetworkErrorBuilder::ERRORS => error
        retry_on_network_error(request, error, retry_number)
      else
        retryable?(request, http_response, retry_number) ? retry_request(request, retry_number) : http_response
      end

      def execute_http_request(request)
        http_request = request.http_request
        http_opts = request.client.config.http_opts
        uri = http_request.uri
        request.requested_at = Time.now

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, **http_opts) { |http| http.request(http_request) }
      end

      def retry_on_network_error(request, error, retry_number)
        raise NetworkErrorBuilder.call(request: request, error: error) if retries_limit_reached?(request, retry_number)

        retry_request(request, retry_number)
      end

      def retry_request(request, current_retry_number)
        sleep(retry_sleep_seconds(request, current_retry_number))
        execute(request, retry_number: current_retry_number + 1)
      end

      def retries_limit_reached?(request, retry_number)
        retry_number >= request.client.config.retries[:count]
      end

      def retry_sleep_seconds(request, current_retry_number)
        seconds_per_retry = request.client.config.retries[:sleep]
        seconds_per_retry[current_retry_number] || seconds_per_retry.last || 1
      end

      def retryable?(request, http_response, retry_number)
        !http_response.is_a?(Net::HTTPSuccess) &&
          !retries_limit_reached?(request, retry_number) &&
          retryable_request?(request, http_response)
      end

      def retryable_request?(request, http_response)
        return true if RETRYABLE_RESPONSES.any? { |retryable_class| http_response.is_a?(retryable_class) }

        retry_unauthorized?(request, http_response)
      end

      def retry_unauthorized?(request, http_response)
        return false unless http_response.is_a?(Net::HTTPUnauthorized) # 401
        return false if http_response.uri.path == Authentication::PATH # it's already an Authentication request

        # set new access-token
        request.http_request["authorization"] = request.client.refresh_access_token.authorization_string
        true
      end
    end
  end
end
