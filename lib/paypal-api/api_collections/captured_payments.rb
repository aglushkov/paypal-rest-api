# frozen_string_literal: true

module PaypalAPI
  #
  # Captured payments APIs `/v2/payments/captures`
  #
  # @see https://developer.paypal.com/docs/api/payments/v2
  #
  class CapturedPayments < APICollection
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
      # Show captured payment details
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#captures_get
      #
      # @param capture_id [String] Capture ID
      # @macro request
      #
      def show(capture_id, query: nil, body: nil, headers: nil)
        client.get("/v2/payments/captures/#{encode(capture_id)}", query: query, body: body, headers: headers)
      end

      #
      # Refund captured payment
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#captures_refund
      #
      # @param capture_id [String] Capture ID
      # @macro request
      #
      def refund(capture_id, query: nil, body: nil, headers: nil)
        client.post("/v2/payments/captures/#{encode(capture_id)}/refund", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
