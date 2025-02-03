# frozen_string_literal: true

module PaypalAPI
  #
  # DEPRECATED: Orders V1
  #
  # @see https://developer.paypal.com/docs/api/orders/v1/
  #
  class OrdersV1 < APICollection
    #
    # Common methods for PaypalAPI::OrdersV1 class and client.orders_v1 instance
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # Create Order
      # @note This method is DEPRECATED on PayPal
      #
      # @see https://developer.paypal.com/docs/api/orders/v1/#orders_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/checkout/orders", query: query, body: body, headers: headers)
      end

      #
      # Show order details
      # @note This method is DEPRECATED on PayPal
      #
      # @see https://developer.paypal.com/docs/api/orders/v1/#orders_get
      #
      # @param id [String] Order ID
      # @macro request
      #
      def show(id, query: nil, body: nil, headers: nil)
        client.get("/v1/checkout/orders/#{encode(id)}", query: query, body: body, headers: headers)
      end

      #
      # Cancel order
      # @note This method is DEPRECATED on PayPal
      #
      # @see https://developer.paypal.com/docs/api/orders/v1/#orders_cancel
      #
      # @param id [String] Order ID
      # @macro request
      #
      def cancel(id, query: nil, body: nil, headers: nil)
        client.delete("/v1/checkout/orders/#{encode(id)}", query: query, body: body, headers: headers)
      end

      #
      # Pay for order
      #
      # @see https://developer.paypal.com/docs/api/orders/v1/#orders_pay
      #
      # @param id [String] Order ID
      # @macro request
      #
      def pay(id, query: nil, body: nil, headers: nil)
        client.post("/v1/checkout/orders/#{encode(id)}/pay", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
