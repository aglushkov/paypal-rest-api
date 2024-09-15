# frozen_string_literal: true

module PaypalAPI
  #
  # Authorized payments APIs `/v2/payments/authorizations`
  #
  # @see https://developer.paypal.com/docs/api/payments/v2
  #
  class AuthorizedPayments < APICollection
    #
    # Common methods for PayplaAPI::AuthorizedPayments class and client.authorized_payments instance
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
      def show(authorization_id, query: nil, body: nil, headers: nil)
        client.get("/v2/payments/authorizations/#{encode(authorization_id)}", query: query, body: body, headers: headers)
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
        client.post("/v2/payments/authorizations/#{encode(authorization_id)}/capture", query: query, body: body, headers: headers)
      end

      # Reauthorize authorized payment
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#authorizations_capture
      #
      # @param authorization_id [String] Authorization ID
      # @macro request
      #
      def reauthorize(authorization_id, query: nil, body: nil, headers: nil)
        client.post("/v2/payments/authorizations/#{encode(authorization_id)}/reauthorize", query: query, body: body, headers: headers)
      end

      # Void authorized payment
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#authorizations_void
      #
      # @param authorization_id [String] Authorization ID
      # @macro request
      #
      def void(authorization_id, query: nil, body: nil, headers: nil)
        client.post("/v2/payments/authorizations/#{encode(authorization_id)}/void", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
