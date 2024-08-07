# frozen_string_literal: true

module PaypalAPI
  #
  # Use in conjunction with the Orders API to authorize payments, capture authorized payments,
  # refund payments that have already been captured, and show payment information.
  #
  # https://developer.paypal.com/docs/api/payments/v2
  #
  class Payments < Collection
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
      # Show details for authorized payment
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#authorizations_get
      #
      # @param authorization_id [String] Authorization ID
      # @macro request
      #
      def show_authorized(authorization_id, query: nil, body: nil, headers: nil)
        client.get("/v2/payments/authorizations/#{authorization_id}", query: query, body: body, headers: headers)
      end

      #
      # Capture authorized payment
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#authorizations_capture
      #
      # @param authorization_id [String] Authorization ID
      # @macro request
      #
      def capture(authorization_id, query: nil, body: nil, headers: nil)
        client.post("/v2/payments/authorizations/#{authorization_id}/capture", query: query, body: body, headers: headers)
      end

      # Reauthorize authorized payment
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#authorizations_capture
      #
      # @param authorization_id [String] Authorization ID
      # @macro request
      #
      def reauthorize(authorization_id, query: nil, body: nil, headers: nil)
        client.post("/v2/payments/authorizations/#{authorization_id}/reauthorize", query: query, body: body, headers: headers)
      end

      # Void authorized payment
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#authorizations_void
      #
      # @param authorization_id [String] Authorization ID
      # @macro request
      #
      def void(authorization_id, query: nil, body: nil, headers: nil)
        client.post("/v2/payments/authorizations/#{authorization_id}/void", query: query, body: body, headers: headers)
      end

      #
      # Show captured payment details
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#captures_get
      #
      # @param capture_id [String] Capture ID
      # @macro request
      #
      def show_captured(capture_id, query: nil, body: nil, headers: nil)
        client.get("/v2/payments/captures/#{capture_id}", query: query, body: body, headers: headers)
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
        client.post("/v2/payments/captures/#{capture_id}/refund", query: query, body: body, headers: headers)
      end

      #
      # Show refund details
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#refunds_get
      #
      # @param refund_id [String]
      # @macro request
      #
      def show_refund(refund_id, query: nil, body: nil, headers: nil)
        client.get("/v2/payments/refunds/#{refund_id}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
