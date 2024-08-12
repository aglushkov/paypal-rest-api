# frozen_string_literal: true

module PaypalAPI
  #
  # Manages tracking information
  #
  # @see https://developer.paypal.com/docs/api/tracking/v1/
  #
  class ShipmentTracking < APICollection
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
      # Add tracking information for multiple PayPal transactions
      #
      # @see https://developer.paypal.com/docs/api/tracking/v1/#trackers-batch_post
      #
      # @macro request
      #
      def add(query: nil, body: nil, headers: nil)
        client.post("/v1/shipping/trackers-batch", query: query, body: body, headers: headers)
      end

      #
      # Update or cancel tracking information for PayPal transaction
      #
      # @see https://developer.paypal.com/docs/api/tracking/v1/#trackers_put
      #
      # @param id [String] Tracker ID
      # @macro request
      #
      def update(id, query: nil, body: nil, headers: nil)
        client.put("/v1/shipping/trackers/#{id}", query: query, body: body, headers: headers)
      end

      #
      # Shows tracking information, by tracker ID, for a PayPal transaction.
      #
      # @see https://developer.paypal.com/docs/api/tracking/v1/#trackers_get
      #
      # @param id [String] Order ID
      # @macro request
      #
      def show(id, query: nil, body: nil, headers: nil)
        client.get("/v1/shipping/trackers/#{id}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
