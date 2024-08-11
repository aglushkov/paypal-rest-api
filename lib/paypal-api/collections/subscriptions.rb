# frozen_string_literal: true

module PaypalAPI
  #
  # Manages subscriptions for recurring PayPal payments
  #
  # @see https://developer.paypal.com/docs/api/subscriptions/v1/
  #
  class Subscriptions < Collection
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
      # Creates a plan that defines pricing and billing cycle details for subscriptions.
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_create
      #
      # @macro request
      #
      def create_plan(query: nil, body: nil, headers: nil)
        client.post("/v1/billing/plans", query: query, body: body, headers: headers)
      end

      #
      # List plans
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_list
      #
      # @macro request
      #
      def list_plans(query: nil, body: nil, headers: nil)
        client.get("/v1/billing/plans", query: query, body: body, headers: headers)
      end

      #
      # Show plan details
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_get
      #
      # @param plan_id [String] Plan ID
      # @macro request
      #
      def show_plan(plan_id, query: nil, body: nil, headers: nil)
        client.get("/v1/billing/plans/#{plan_id}", query: query, body: body, headers: headers)
      end

      #
      # Update plan
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_patch
      #
      # @param plan_id [String] Plan ID
      # @macro request
      #
      def update_plan(plan_id, query: nil, body: nil, headers: nil)
        client.patch("/v1/billing/plans/#{plan_id}", query: query, body: body, headers: headers)
      end

      #
      # Activate plan
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_activate
      #
      # @param plan_id [String] Plan ID
      # @macro request
      #
      def activate_plan(plan_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/plans/#{plan_id}/activate", query: query, body: body, headers: headers)
      end

      #
      # Deactivate plan
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_deactivate
      #
      # @param plan_id [String] Plan ID
      # @macro request
      #
      def deactivate_plan(plan_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/plans/#{plan_id}/deactivate", query: query, body: body, headers: headers)
      end

      #
      # Update pricing
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_deactivate
      #
      # @param plan_id [String] Plan ID
      # @macro request
      #
      def update_plan_pricing(plan_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/plans/#{plan_id}/update-pricing-schemes", query: query, body: body, headers: headers)
      end

      #
      # Create subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_create
      #
      # @macro request
      #
      def create_subscription(query: nil, body: nil, headers: nil)
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
      def show_subscription(subscription_id, query: nil, body: nil, headers: nil)
        client.get("/v1/billing/subscriptions/#{subscription_id}", query: query, body: body, headers: headers)
      end

      #
      # Update subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_patch
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def update_subscription(subscription_id, query: nil, body: nil, headers: nil)
        client.patch("/v1/billing/subscriptions/#{subscription_id}", query: query, body: body, headers: headers)
      end

      #
      # Revise plan or quantity of subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_revise
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def revise_subscription(subscription_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions/#{subscription_id}/revise", query: query, body: body, headers: headers)
      end

      #
      # Suspend subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_suspend
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def suspend_subscription(subscription_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions/#{subscription_id}/suspend", query: query, body: body, headers: headers)
      end

      #
      # Cancel subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_cancel
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def cancel_subscription(subscription_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions/#{subscription_id}/cancel", query: query, body: body, headers: headers)
      end

      #
      # Activate subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_activate
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def activate_subscription(subscription_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions/#{subscription_id}/activate", query: query, body: body, headers: headers)
      end

      #
      # Capture authorized payment on subscription
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#subscriptions_capture
      #
      # @param subscription_id [String] Subscripton ID
      # @macro request
      #
      def capture_subscription(subscription_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/subscriptions/#{subscription_id}/capture", query: query, body: body, headers: headers)
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
        client.get("/v1/billing/subscriptions/#{subscription_id}/transactions", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
