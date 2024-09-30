# frozen_string_literal: true

module PaypalAPI
  #
  # PaypalAPI Client
  #
  class Client
    include AccessTokenMethods
    include APIMethods
    include EnvironmentMethods
    include HTTPMethods

    # Paypal environment
    attr_reader :env

    # Gem Configuration
    #
    # @return [Config] Gem Configuration
    attr_reader :config

    # Registered callbacks
    #
    # @return [Hash] Registered callbacks
    attr_reader :callbacks

    # Initializes Client
    # @api public
    #
    # @param client_id [String] PayPal client id
    # @param client_secret [String] PayPal client secret
    # @param live [Boolean] PayPal live/sandbox mode
    # @param http_opts [Hash] Net::Http opts for all requests
    # @param retries [Hash] Retries configuration
    #
    # @return [Client] Initialized client
    #
    def initialize(client_id:, client_secret:, live: false, http_opts: nil, retries: nil, cache: nil)
      @env = PaypalAPI::Environment.new(client_id: client_id, client_secret: client_secret, live: live)
      @config = PaypalAPI::Config.new(http_opts: http_opts, retries: retries, cache: cache)

      @callbacks = {
        before: [],
        after_success: [],
        after_fail: [],
        after_network_error: []
      }.freeze

      @access_token = nil
    end

    # Registers callback
    #
    # @param callback_name [Symbol] Callback name.
    #   Allowed values: :before, :after_success, :after_fail, :after_network_error
    #
    # @param block [Proc] Block that must be call
    #   For `:before` callback proc should accept 2 params -
    #    request [Request], context [Hash]
    #
    #   For `:after_success` callback proc should accept 3 params -
    #     request [Request], context [Hash], response [Response]
    #
    #   For `:after_fail` callback proc should accept 3 params -
    #     request [Request], context [Hash], error [StandardError]
    #
    #   For `:after_network_error` callback proc should accept 3 params -
    #     request [Request], context [Hash], response [Response]
    #
    # @return [void]
    def add_callback(callback_name, &block)
      callbacks.fetch(callback_name) << block
    end

    #
    # Verifies Webhook
    #
    # It requires one-time request to download and cache certificate.
    # If local verification returns false it tries to verify webhook online.
    #
    # @api public
    # @example
    #
    #  class Webhooks::PaypalController < ApplicationController
    #    def create
    #      webhook_id = ENV['PAYPAL_WEBHOOK_ID'] # PayPal registered webhook ID for current URL
    #      headers = request.headers # must respond to #[] to get headers
    #      body = request.raw_post # must be a raw String body
    #
    #      webhook_is_valid = PaypalAPI.verify_webhook(webhook_id: webhook_id, headers: headers, body: body)
    #      webhook_is_valid ? handle_webhook_event(body) : log_error(webhook_id, headers, body)
    #
    #      head :no_content
    #    end
    #  end
    #
    # @param webhook_id [String] webhook_id provided by PayPal when webhook was registered
    # @param headers [Hash,#[]] webhook request headers
    # @param raw_body [String] webhook request raw body string
    #
    # @return [Boolean] webhook event is valid
    #
    def verify_webhook(webhook_id:, headers:, raw_body:)
      WebhookVerifier.new(self).call(webhook_id: webhook_id, headers: headers, raw_body: raw_body)
    end
  end
end
