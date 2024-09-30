# frozen_string_literal: true

module PaypalAPI
  #
  # Executes PaypalAPI::Request and returns PaypalAPI::Response or raises PaypalAPI::Error
  #
  class RequestExecutor
    attr_reader :client, :request, :http_opts, :retries, :callbacks, :callbacks_context

    def initialize(client, request)
      @client = client
      @request = request
      @http_opts = {use_ssl: request.uri.is_a?(URI::HTTPS), **client.config.http_opts}
      @retries = client.config.retries
      @callbacks = client.callbacks
      @callbacks_context = {retries_enabled: retries[:enabled], retries_count: retries[:count]}
    end

    #
    # Executes prepared Request, handles retries and preparation of errors
    #
    # @return [Response] Response
    #
    def call
      response = execute_request
      raise FailedRequestErrorBuilder.call(request: request, response: response) if response.failed?

      response
    end

    private

    def start_execution(retry_number)
      callbacks_context[:retry_number] = retry_number
      run_callbacks(:before)
      execute_net_http_request
    end

    def handle_network_error(error, retry_number)
      will_retry = retries[:enabled] && !retries_limit_reached?(retry_number)
      callbacks_context[:will_retry] = will_retry
      run_callbacks(:after_network_error, error)
      raise NetworkErrorBuilder.call(request: request, error: error) unless will_retry

      retry_request(retry_number)
    end

    def handle_success_response(response)
      callbacks_context.delete(:will_retry)
      run_callbacks(:after_success, response)
      response
    end

    def handle_failed_response(response, retry_number)
      will_retry = retries[:enabled] && retryable?(response, retry_number)
      callbacks_context[:will_retry] = will_retry
      run_callbacks(:after_fail, response)
      will_retry ? retry_request(retry_number) : response
    end

    def execute_request(retry_number: 0)
      response = start_execution(retry_number)
    rescue => error
      unknown_network_error?(error) ? handle_unknown_error(error) : handle_network_error(error, retry_number)
    else
      response.success? ? handle_success_response(response) : handle_failed_response(response, retry_number)
    end

    def execute_net_http_request
      uri = request.uri

      http_response =
        Net::HTTP.start(uri.hostname, uri.port, **http_opts) do |http|
          http.max_retries = 0 # we have custom retries logic
          http.request(request.http_request)
        end

      Response.new(http_response, request: request)
    end

    def retry_request(current_retry_number)
      sleep_time = retry_sleep_seconds(current_retry_number)
      sleep(sleep_time) if sleep_time.positive?
      execute_request(retry_number: current_retry_number + 1)
    end

    def retries_limit_reached?(retry_number)
      retry_number >= retries[:count]
    end

    def retry_sleep_seconds(current_retry_number)
      seconds_per_retry = retries[:sleep]
      seconds_per_retry[current_retry_number] || seconds_per_retry.last || 1
    end

    def retryable?(response, retry_number)
      response.failed? &&
        !retries_limit_reached?(retry_number) &&
        retryable_request?(response)
    end

    def retryable_request?(response)
      return true if response.retryable?

      retry_unauthorized?(response)
    end

    def retry_unauthorized?(response)
      return false unless response.unauthorized? # 401
      return false if request.path == Authentication::PATH # it's already an Authentication request

      # set new access-token
      request.http_request["authorization"] = client.refresh_access_token.authorization_string
      true
    end

    def unknown_network_error?(error)
      NetworkErrorBuilder::ERRORS.none? { |network_error_class| error.is_a?(network_error_class) }
    end

    def handle_unknown_error(error)
      raise error
    end

    def run_callbacks(callback_name, resp = nil)
      callbacks[callback_name].each { |callback| callback.call(request, callbacks_context, resp) }
    end
  end
end
