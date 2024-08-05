# frozen_string_literal: true

module PaypalAPI
  #
  # Create, update, retrieve, authorize, and capture orders.
  #
  # https://developer.paypal.com/docs/api/orders/v2/
  #
  class Orders < Collection
    module APIs
      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_authorize
      #
      def authorize(id, query: nil, body: nil, headers: nil)
        client.post("/v2/checkout/orders/#{id}/authorize", query: query, body: body, headers: headers)
      end

      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_create
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v2/checkout/orders", query: query, body: body, headers: headers)
      end

      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_get
      #
      def show(id, query: nil, body: nil, headers: nil)
        client.get("/v2/checkout/orders/#{id}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
