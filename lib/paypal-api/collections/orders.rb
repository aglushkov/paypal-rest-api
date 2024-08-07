# frozen_string_literal: true

module PaypalAPI
  #
  # Create, update, retrieve, authorize, and capture orders.
  #
  # https://developer.paypal.com/docs/api/orders/v2/
  #
  class Orders < Collection
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
      # Create Order
      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_create
      #
      # @param id [String] Order ID
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v2/checkout/orders", query: query, body: body, headers: headers)
      end

      #
      # Show order details
      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_get
      #
      # @param id [String] Order ID
      # @macro request
      #
      def show(id, query: nil, body: nil, headers: nil)
        client.get("/v2/checkout/orders/#{id}", query: query, body: body, headers: headers)
      end

      #
      # Update order
      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_patch
      #
      # @param id [String] Order ID
      # @macro request
      #
      def update(id, query: nil, body: nil, headers: nil)
        client.patch("/v2/checkout/orders/#{id}", query: query, body: body, headers: headers)
      end

      #
      # Confirm the Order
      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_confirm
      #
      # @param id [String] Order ID
      # @macro request
      #
      def confirm(id, query: nil, body: nil, headers: nil)
        client.post("/v2/checkout/orders/#{id}/confirm-payment-source", query: query, body: body, headers: headers)
      end

      #
      # Authorize payment for order
      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_authorize
      #
      # @param id [String] Order ID
      # @macro request
      #
      def authorize(id, query: nil, body: nil, headers: nil)
        client.post("/v2/checkout/orders/#{id}/authorize", query: query, body: body, headers: headers)
      end

      #
      # Capture payment for order
      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_capture
      #
      # @param id [String] Order ID
      # @macro request
      #
      def capture(id, query: nil, body: nil, headers: nil)
        client.post("/v2/checkout/orders/#{id}/capture", query: query, body: body, headers: headers)
      end

      #
      # Add tracking information for an Order
      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_track_create
      #
      # @param id [String] Order ID
      # @macro request
      #
      def track(id, query: nil, body: nil, headers: nil)
        client.post("/v2/checkout/orders/#{id}/track", query: query, body: body, headers: headers)
      end

      #
      # Update or cancel tracking information for a PayPal order
      #
      # @see https://developer.paypal.com/docs/api/orders/v2/#orders_trackers_patch
      #
      # @param id [String] Order ID
      # @param tracker_id [String] Tracker ID
      # @macro request
      #
      def update_tracker(id, tracker_id, query: nil, body: nil, headers: nil)
        client.patch("/v2/checkout/orders/#{id}/trackers/#{tracker_id}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
