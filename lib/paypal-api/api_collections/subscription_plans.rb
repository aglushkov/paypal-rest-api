# frozen_string_literal: true

module PaypalAPI
  #
  # Manages subscriptions for recurring PayPal payments
  #
  # @see https://developer.paypal.com/docs/api/subscriptions/v1/
  #
  class SubscriptionPlans < APICollection
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
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/billing/plans", query: query, body: body, headers: headers)
      end

      #
      # List plans
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_list
      #
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
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
      def show(plan_id, query: nil, body: nil, headers: nil)
        client.get("/v1/billing/plans/#{encode(plan_id)}", query: query, body: body, headers: headers)
      end

      #
      # Update plan
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_patch
      #
      # @param plan_id [String] Plan ID
      # @macro request
      #
      def update(plan_id, query: nil, body: nil, headers: nil)
        client.patch("/v1/billing/plans/#{encode(plan_id)}", query: query, body: body, headers: headers)
      end

      #
      # Activate plan
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_activate
      #
      # @param plan_id [String] Plan ID
      # @macro request
      #
      def activate(plan_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/plans/#{encode(plan_id)}/activate", query: query, body: body, headers: headers)
      end

      #
      # Deactivate plan
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_deactivate
      #
      # @param plan_id [String] Plan ID
      # @macro request
      #
      def deactivate(plan_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/plans/#{encode(plan_id)}/deactivate", query: query, body: body, headers: headers)
      end

      #
      # Update pricing
      #
      # @see https://developer.paypal.com/docs/api/subscriptions/v1/#plans_deactivate
      #
      # @param plan_id [String] Plan ID
      # @macro request
      #
      def update_pricing(plan_id, query: nil, body: nil, headers: nil)
        client.post("/v1/billing/plans/#{encode(plan_id)}/update-pricing-schemes", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
