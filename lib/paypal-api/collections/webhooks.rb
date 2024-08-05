# frozen_string_literal: true

module PaypalAPI
  #
  # https://developer.paypal.com/docs/api/webhooks/v1/
  #
  class Webhooks < Collection
    module APIs
      #
      # https://developer.paypal.com/docs/api/webhooks/v1/#webhooks_post
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/notifications/webhooks", query: query, body: body, headers: headers)
      end

      #
      # https://developer.paypal.com/docs/api/webhooks/v1/#webhooks_delete
      #
      def delete(webhook_id, query: nil, body: nil, headers: nil)
        client.delete("/v1/notifications/webhooks/#{webhook_id}", query: query, body: body, headers: headers)
      end

      #
      # https://developer.paypal.com/docs/api/webhooks/v1/#webhooks_list
      #
      def list(query: nil, body: nil, headers: nil)
        client.get("/v1/notifications/webhooks", query: query, body: body, headers: headers)
      end

      #
      # https://developer.paypal.com/docs/api/webhooks/v1/#webhooks_get
      #
      def show(webhook_id, query: nil, body: nil, headers: nil)
        client.get("/v1/notifications/webhooks/#{webhook_id}", query: query, body: body, headers: headers)
      end

      #
      # https://developer.paypal.com/docs/api/webhooks/v1/#webhooks_update
      #
      def update(webhook_id, query: nil, body: nil, headers: nil)
        client.patch("/v1/notifications/webhooks/#{webhook_id}", query: query, body: body, headers: headers)
      end

      #
      # https://developer.paypal.com/docs/api/webhooks/v1/#verify-webhook-signature_post
      #
      def verify(query: nil, body: nil, headers: nil)
        client.post("/v1/notifications/verify-webhook-signature", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
