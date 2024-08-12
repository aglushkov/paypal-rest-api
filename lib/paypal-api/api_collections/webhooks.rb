# frozen_string_literal: true

module PaypalAPI
  #
  # https://developer.paypal.com/docs/api/webhooks/v1/
  #
  class Webhooks < APICollection
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
      # Create webhook
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks_post
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/notifications/webhooks", query: query, body: body, headers: headers)
      end

      #
      # List webhooks
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks_list
      #
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
        client.get("/v1/notifications/webhooks", query: query, body: body, headers: headers)
      end

      #
      # Show webhook details
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks_get
      #
      # @param webhook_id [String] Webhook ID
      # @macro request
      #
      def show(webhook_id, query: nil, body: nil, headers: nil)
        client.get("/v1/notifications/webhooks/#{webhook_id}", query: query, body: body, headers: headers)
      end

      #
      # Update webhook
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks_update
      #
      # @param webhook_id [String] Webhook ID
      # @macro request
      #
      def update(webhook_id, query: nil, body: nil, headers: nil)
        client.patch("/v1/notifications/webhooks/#{webhook_id}", query: query, body: body, headers: headers)
      end

      #
      # Delete webhook
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks_delete
      #
      # @param webhook_id [String] Webhook ID
      # @macro request
      #
      def delete(webhook_id, query: nil, body: nil, headers: nil)
        client.delete("/v1/notifications/webhooks/#{webhook_id}", query: query, body: body, headers: headers)
      end

      #
      # List event subscriptions for webhook
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#event-types_list
      #
      # @param webhook_id [String] Webhook ID
      # @macro request
      #
      def event_types(webhook_id, query: nil, body: nil, headers: nil)
        client.get("/v1/notifications/webhooks/#{webhook_id}/event-types", query: query, body: body, headers: headers)
      end

      #
      # Verify webhook signature
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#verify-webhook-signature_post
      #
      # @macro request
      #
      def verify(query: nil, body: nil, headers: nil)
        client.post("/v1/notifications/verify-webhook-signature", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
