# frozen_string_literal: true

module PaypalAPI
  #
  # https://developer.paypal.com/docs/api/webhooks/v1/
  #
  class WebhookLookups < APICollection
    #
    # Common methods for PaypalAPI::WebhookLookups class and client.webhook_lookups instance
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # Create webhook lookup
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks-lookup_post
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/notifications/webhooks-lookup", query: query, body: body, headers: headers)
      end

      #
      # List webhook lookups
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks-lookup_list
      #
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
        client.get("/v1/notifications/webhooks-lookup", query: query, body: body, headers: headers)
      end

      #
      # Show webhook lookup details
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks-lookup_get
      #
      # @param webhook_lookup_id [String] Webhook lookup ID
      # @macro request
      #
      def show(webhook_lookup_id, query: nil, body: nil, headers: nil)
        client.get("/v1/notifications/webhooks-lookup/#{encode(webhook_lookup_id)}", query: query, body: body, headers: headers)
      end

      #
      # Delete webhook lookup
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks-lookup_delete
      #
      # @param webhook_lookup_id [String] Webhook lookup ID
      # @macro request
      #
      def delete(webhook_lookup_id, query: nil, body: nil, headers: nil)
        client.delete("/v1/notifications/webhooks-lookup/#{encode(webhook_lookup_id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
