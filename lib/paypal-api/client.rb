# frozen_string_literal: true

module PaypalAPI
  #
  # PaypalAPI Client
  #
  class Client
    attr_reader :config

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
    def initialize(client_id:, client_secret:, live: nil, http_opts: nil, retries: nil)
      @config = PaypalAPI::Config.new(
        client_id: client_id,
        client_secret: client_secret,
        live: live,
        http_opts: http_opts,
        retries: retries
      )

      @access_token = nil
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
      response = authentication.generate_access_token

      @access_token = AccessToken.new(
        requested_at: response.requested_at,
        expires_in: response.fetch(:expires_in),
        access_token: response.fetch(:access_token),
        token_type: response.fetch(:token_type)
      )
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

    # @return [PayoutItems] PayoutItems APIs collection
    def payout_items
      PayoutItems.new(self)
    end

    # @return [Payouts] Payouts APIs collection
    def payouts
      Payouts.new(self)
    end

    # @return [Redunds] Refunds APIs collection
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
      RequestExecutor.call(request)
    end
  end
end
