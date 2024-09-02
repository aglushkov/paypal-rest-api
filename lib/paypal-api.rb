# frozen_string_literal: true

#
# PaypalAPI is a main gem module.
#
module PaypalAPI
  class << self
    # Sets client
    # @api public
    #
    # @example Initializing new global client
    #   PaypalAPI.client = PaypalAPI::Client.new(
    #     client_id: ENV.fetch('PAYPAL_CLIENT_ID'),
    #     client_secret: ENV.fetch('PAYPAL_CLIENT_SECRET'),
    #     live: false
    #   )
    #
    # @return [Client] PaypalAPI client
    attr_writer :client

    # Checks if PayPal LIVE environment enabled
    # @return [Boolean] Checks if PayPal LIVE environment enabled
    def live?
      client.live?
    end

    # Checks if PayPal SANDBOX environment enabled
    # @return [Boolean] Checks if PayPal SANDBOX environment enabled
    def sandbox?
      client.sandbox?
    end

    # Base API URL
    # @return [String] Base API URL
    def api_url
      client.api_url
    end

    # Base WEB URL
    # @return [String] Base WEB URL
    def web_url
      client.web_url
    end

    # @!macro [new] request
    #
    #   @api public
    #   @example
    #     PaypalAPI.$0("/path1/path2", query: query, body: body, headers: headers)
    #   @param path [String] Request path
    #   @param query [Hash, nil] Request query parameters
    #   @param body [Hash, nil] Request body parameters
    #   @param headers [Hash, nil] Request headers
    #
    #   @return [Response] Response object
    #

    # @!method post(path, query: nil, body: nil, headers: nil)
    #
    #   Executes POST http request
    #   @macro request
    #
    # @!method get(path, query: nil, body: nil, headers: nil)
    #
    #   Executes GET http request
    #   @macro request
    #
    # @!method patch(path, query: nil, body: nil, headers: nil)
    #
    #   Executes PATCH http request
    #   @macro request
    #
    # @!method put(path, query: nil, body: nil, headers: nil)
    #
    #   Executes PUT http request
    #   @macro request

    # @!method delete(path, query: nil, body: nil, headers: nil)
    #
    #   Executes DELETE http request
    #   @macro request
    #
    [:post, :get, :patch, :put, :delete].each do |method_name|
      define_method(method_name) do |path, query: nil, body: nil, headers: nil|
        client.public_send(method_name, path, query: query, body: body, headers: headers)
      end
    end

    #
    # Verifies Webhook
    #
    # It requires one-time request to download and cache certificate.
    # If local verification returns false it tries to verify webhook online.
    #
    # @see Client#verify_webhook
    #
    def verify_webhook(webhook_id:, headers:, raw_body:)
      client.verify_webhook(webhook_id: webhook_id, headers: headers, raw_body: raw_body)
    end

    #
    # @!macro [new] api_collection
    #   $0 APIs collection
    #   @api public
    #   @example
    #     PaypalAPI.$0
    #

    #
    # @!method authentication
    #   @macro api_collection
    #   @return [Authentication]
    #
    # @!method authorized_payments
    #   @macro api_collection
    #   @return [AuthorizedPayments]
    #
    # @!method captured_payments
    #   @macro api_collection
    #   @return [CapturedPayments]
    #
    # @!method catalog_products
    #   @macro api_collection
    #   @return [CatalogProducts]
    #
    # @!method disputes
    #   @macro api_collection
    #   @return [Disputes]
    #
    # @!method invoice_templates
    #   @macro api_collection
    #   @return [InvoiceTemplates]
    #
    # @!method invoices
    #   @macro api_collection
    #   @return [Invoices]
    #
    # @!method orders
    #   @macro api_collection
    #   @return [Orders]
    #
    # @!method payout_items
    #   @macro api_collection
    #   @return [PayoutItems]
    #
    # @!method payouts
    #   @macro api_collection
    #   @return [Payouts]
    #
    # @!method refunds
    #   @macro api_collection
    #   @return [Refunds]
    #
    # @!method referenced_payout_items
    #   @macro api_collection
    #   @return [ReferencedPayoutItems]
    #
    # @!method referenced_payouts
    #   @macro api_collection
    #   @return [ReferencedPayouts]
    #
    # @!method shipment_tracking
    #   @macro api_collection
    #   @return [ShipmentTracking]
    #
    # @!method subscriptions
    #   @macro api_collection
    #   @return [Subscriptions]
    #
    # @!method subscription_plans
    #   @macro api_collection
    #   @return [SubscriptionPlans]
    #
    # @!method user_info
    #   @macro api_collection
    #   @return [UserInfo]
    #
    # @!method users
    #   @macro api_collection
    #   @return [Users]
    #
    # @!method webhooks
    #   @macro api_collection
    #   @return [Webhooks]
    #
    # @!method webhook_events
    #   @macro api_collection
    #   @return [WebhookEvents]
    #
    # @!method webhook_lookups
    #   @macro api_collection
    #   @return [WebhookLookups]
    #
    %i[
      authentication
      authorized_payments
      captured_payments
      catalog_products
      disputes
      invoice_templates
      invoices
      orders
      payout_items
      payouts
      refunds
      referenced_payout_items
      referenced_payouts
      shipment_tracking
      subscriptions
      subscription_plans
      user_info
      users
      webhooks
      webhook_events
      webhook_lookups
    ].each do |method_name|
      define_method(method_name) do
        client.public_send(method_name)
      end
    end

    # Globally set Client object
    # @api public
    # @example
    #   PaypalAPI.client
    # @return [Client]
    def client
      raise "#{name}.client must be set" unless @client

      @client
    end
  end
end

require_relative "paypal-api/access_token"
require_relative "paypal-api/api_collection"
require_relative "paypal-api/environment"
require_relative "paypal-api/client"
require_relative "paypal-api/config"
require_relative "paypal-api/error"
require_relative "paypal-api/failed_request_error_builder"
require_relative "paypal-api/network_error_builder"
require_relative "paypal-api/request"
require_relative "paypal-api/request_executor"
require_relative "paypal-api/response"
require_relative "paypal-api/webhook_verifier"
require_relative "paypal-api/webhook_verifier/certs_cache"
require_relative "paypal-api/api_collections/authentication"
require_relative "paypal-api/api_collections/authorized_payments"
require_relative "paypal-api/api_collections/captured_payments"
require_relative "paypal-api/api_collections/catalog_products"
require_relative "paypal-api/api_collections/disputes"
require_relative "paypal-api/api_collections/invoice_templates"
require_relative "paypal-api/api_collections/invoices"
require_relative "paypal-api/api_collections/orders"
require_relative "paypal-api/api_collections/payout_items"
require_relative "paypal-api/api_collections/payouts"
require_relative "paypal-api/api_collections/refunds"
require_relative "paypal-api/api_collections/referenced_payout_items"
require_relative "paypal-api/api_collections/referenced_payouts"
require_relative "paypal-api/api_collections/shipment_tracking"
require_relative "paypal-api/api_collections/subscriptions"
require_relative "paypal-api/api_collections/subscription_plans"
require_relative "paypal-api/api_collections/user_info"
require_relative "paypal-api/api_collections/users"
require_relative "paypal-api/api_collections/webhooks"
require_relative "paypal-api/api_collections/webhook_events"
require_relative "paypal-api/api_collections/webhook_lookups"
