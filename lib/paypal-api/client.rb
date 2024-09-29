# frozen_string_literal: true

module PaypalAPI
  #
  # PaypalAPI Client
  #
  class Client
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

    # Checks if PayPal LIVE environment enabled
    # @return [Boolean] Checks if PayPal LIVE environment enabled
    def live?
      env.live?
    end

    # Checks if PayPal SANDBOX environment enabled
    # @return [Boolean] Checks if PayPal SANDBOX environment enabled
    def sandbox?
      env.sandbox?
    end

    # Base API URL
    # @return [String] Base API URL
    def api_url
      env.api_url
    end

    # Base WEB URL
    # @return [String] Base WEB URL
    def web_url
      env.web_url
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
    # Checks cached access token is expired and returns it or generates new one
    #
    # @return [AccessToken] AccessToken object
    #
    def access_token
      (@access_token.nil? || @access_token.expired?) ? refresh_access_token : @access_token
    end

    #
    # Generates and caches new AccessToken
    #
    # @return [AccessToken] new AccessToken object
    #
    def refresh_access_token
      requested_at = Time.now
      response = authentication.generate_access_token

      @access_token = AccessToken.new(
        requested_at: requested_at,
        expires_in: response.fetch(:expires_in),
        access_token: response.fetch(:access_token),
        token_type: response.fetch(:token_type)
      )
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

    # @!macro [new] request
    # @param path [String] Request path
    # @param query [Hash, nil] Request query parameters
    # @param body [Hash, nil] Request body parameters
    # @param headers [Hash, nil] Request headers
    #
    # @return [Response] Response object

    #
    # Executes POST http request
    #
    # @macro request
    #
    def post(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Post, path, query: query, body: body, headers: headers)
    end

    #
    # Executes GET http request
    #
    # @macro request
    #
    def get(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Get, path, query: query, body: body, headers: headers)
    end

    #
    # Executes PATCH http request
    #
    # @macro request
    #
    def patch(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Patch, path, query: query, body: body, headers: headers)
    end

    #
    # Executes PUT http request
    #
    # @macro request
    #
    def put(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Put, path, query: query, body: body, headers: headers)
    end

    #
    # Executes DELETE http request
    #
    # @macro request
    #
    def delete(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Delete, path, query: query, body: body, headers: headers)
    end

    # @return [AuthorizedPayments] AuthorizedPayments APIs collection
    def authorized_payments
      AuthorizedPayments.new(self)
    end

    # @return [CapturedPayments] CapturedPayments APIs collection
    def captured_payments
      CapturedPayments.new(self)
    end

    # @return [Authentication] Authentication APIs collection
    def authentication
      Authentication.new(self)
    end

    # @return [CatalogProducts] Catalog Products APIs collection
    def catalog_products
      CatalogProducts.new(self)
    end

    # @return [Disputes] Disputes APIs collection
    def disputes
      Disputes.new(self)
    end

    # @return [InvoiceTemplates] InvoiceTemplates APIs collection
    def invoice_templates
      InvoiceTemplates.new(self)
    end

    # @return [Invoices] Invoices APIs collection
    def invoices
      Invoices.new(self)
    end

    # @return [Orders] Orders APIs collection
    def orders
      Orders.new(self)
    end

    # @return [PartnerReferrals] PartnerReferrals APIs collection
    def partner_referrals
      PartnerReferrals.new(self)
    end

    # @return [PaymentTokens] PaymentTokens APIs collection
    def payment_tokens
      PaymentTokens.new(self)
    end

    # @return [PayoutItems] PayoutItems APIs collection
    def payout_items
      PayoutItems.new(self)
    end

    # @return [Payouts] Payouts APIs collection
    def payouts
      Payouts.new(self)
    end

    # @return [Refunds] Refunds APIs collection
    def refunds
      Refunds.new(self)
    end

    # @return [ReferencedPayoutItems] ReferencedPayoutItems APIs collection
    def referenced_payout_items
      ReferencedPayoutItems.new(self)
    end

    # @return [ReferencedPayouts] ReferencedPayouts APIs collection
    def referenced_payouts
      ReferencedPayouts.new(self)
    end

    # @return [SetupTokens] SetupTokens APIs collection
    def setup_tokens
      SetupTokens.new(self)
    end

    # @return [ShipmentTracking] Shipment Tracking APIs collection
    def shipment_tracking
      ShipmentTracking.new(self)
    end

    # @return [Subscriptions] Subscriptions APIs collection
    def subscriptions
      Subscriptions.new(self)
    end

    # @return [SubscriptionPlans] Subscription Plans APIs collection
    def subscription_plans
      SubscriptionPlans.new(self)
    end

    # @return [UserInfo] User Info APIs collection
    def user_info
      UserInfo.new(self)
    end

    # @return [Users] Users Management APIs collection
    def users
      Users.new(self)
    end

    # @return [Webhooks] Webhooks APIs collection
    def webhooks
      Webhooks.new(self)
    end

    # @return [WebhookEvents] Webhook Events APIs collection
    def webhook_lookups
      WebhookLookups.new(self)
    end

    # @return [WebhookEvents] Webhook Lookups APIs collection
    def webhook_events
      WebhookEvents.new(self)
    end

    private

    def execute_request(http_method, path, query: nil, body: nil, headers: nil)
      request = Request.new(self, http_method, path, query: query, body: body, headers: headers)
      RequestExecutor.new(self, request).call
    end
  end
end
