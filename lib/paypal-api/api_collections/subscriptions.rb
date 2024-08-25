# frozen_string_literal: true

module PaypalAPI
  #
  # Manages subscriptions for recurring PayPal payments
  #
  # @see https://developer.paypal.com/docs/api/subscriptions/v1/
  #
  class Subscriptions < APICollection
    #
    # Common class and instance methods
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # Create subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions", query: query, body: body, headers: headers)
      end

      #
      # Show subscription details
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_get
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def show(subscription_id, query: nil, body: nil, headers: nil)
        client.get("/v1/billing/subscriptions/#{encode(subscription_id)}", query: query, body: body, headers: headers)
      end

      #
      # Update subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_patch
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def update(subscription_id, query: nil, body: nil, headers: nil)
        client.patch("/v1/billing/subscriptions/#{encode(subscription_id)}", query: query, body: body, headers: headers)
      end

      #
      # Revise plan or quantity of subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_revise
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def revise(subscription_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions/#{encode(subscription_id)}/revise", query: query, body: body, headers: headers)
      end

      #
      # Suspend subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_suspend
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def suspend(subscription_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions/#{encode(subscription_id)}/suspend", query: query, body: body, headers: headers)
      end

      #
      # Cancel subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_cancel
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def cancel(subscription_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions/#{encode(subscription_id)}/cancel", query: query, body: body, headers: headers)
      end

      #
      # Activate subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_activate
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def activate(subscription_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions/#{encode(subscription_id)}/activate", query: query, body: body, headers: headers)
      end

      #
      # Capture authorized payment on subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_capture
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def capture(subscription_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions/#{encode(subscription_id)}/capture", query: query, body: body, headers: headers)
      end

      #
      # List transactions for subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_transactions
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def transactions(subscription_id, query: nil, body: nil, headers: nil)
        client.get("/v1/billing/subscriptions/#{encode(subscription_id)}/transactions", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
