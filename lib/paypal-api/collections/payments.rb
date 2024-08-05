# frozen_string_literal: true

module PaypalAPI
  #
  # Use in conjunction with the Orders API to authorize payments, capture authorized payments,
  # refund payments that have already been captured, and show payment information.
  #
  # https://developer.paypal.com/docs/api/payments/v2
  #
  class Payments < Collection
    module APIs
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#authorizations_capture
      #
      def capture(authorization_id, query: nil, body: nil, headers: nil)
        client.post("/v2/payments/authorizations/#{authorization_id}/capture", query: query, body: body, headers: headers)
      end

      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#captures_refund
      #
      def refund(capture_id, query: nil, body: nil, headers: nil)
        client.post("/v2/payments/captures/#{capture_id}/refund", query: query, body: body, headers: headers)
      end

      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#authorizations_get
      #
      def show_authorized(authorization_id, query: nil, body: nil, headers: nil)
        client.get("/v2/payments/authorizations/#{authorization_id}", query: query, body: body, headers: headers)
      end

      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#captures_get
      #
      def show_captured(capture_id, query: nil, body: nil, headers: nil)
        client.get("/v2/payments/captures/#{capture_id}", query: query, body: body, headers: headers)
      end

      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#authorizations_void
      #
      def void(authorization_id, query: nil, body: nil, headers: nil)
        client.post("/v2/payments/authorizations/#{authorization_id}/void", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
