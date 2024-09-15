# frozen_string_literal: true

module PaypalAPI
  #
  # https://developer.paypal.com/docs/api/webhooks/v1/
  #
  class WebhookEvents < APICollection
    #
    # Common methods for PaypalAPI::WebhookEvents class and client.webhook_events instance
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      # Lists available events to which any webhook can subscribe
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks-event-types_list
      #
      # @macro request
      #
      def available(query: nil, body: nil, headers: nil)
        client.get("/v1/notifications/webhooks-event-types", query: query, body: body, headers: headers)
      end

      #
      # List event notifications
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks-events_list
      #
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
        client.get("/v1/notifications/webhooks-events", query: query, body: body, headers: headers)
      end

      #
      # Show event notification details
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks-events_get
      #
      # @param event_id [String] Event ID
      # @macro request
      #
      def show(event_id, query: nil, body: nil, headers: nil)
        client.get("/v1/notifications/webhooks-events/#{encode(event_id)}", query: query, body: body, headers: headers)
      end

      #
      # Resend event notification
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#webhooks-events_resend
      #
      # @param event_id [String] Event ID
      # @macro request
      #
      def resend(event_id, query: nil, body: nil, headers: nil)
        client.post("/v1/notifications/webhooks-events/#{encode(event_id)}/resend", query: query, body: body, headers: headers)
      end

      #
      # Simulate webhook event
      #
      # @see https://developer.paypal.com/docs/api/webhooks/v1/#simulate-event_post
      #
      # @macro request
      #
      def simulate(query: nil, body: nil, headers: nil)
        client.post("/v1/notifications/simulate-event", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
