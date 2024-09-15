# frozen_string_literal: true

module PaypalAPI
  #
  # Payment Method Tokens
  #
  # @see https://developer.paypal.com/docs/api/payment-tokens/v3/
  #
  class PaymentTokens < APICollection
    #
    # Common methods for PaypalAPI::PaymentTokens class and client.payment_tokens instance
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # Create payment token for a given payment source
      #
      # @see https://developer.paypal.com/docs/api/payment-tokens/v3/#payment-tokens_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v3/vault/payment-tokens", query: query, body: body, headers: headers)
      end

      #
      # List all payment tokens
      #
      # @see https://developer.paypal.com/docs/api/payment-tokens/v3/#customer_payment-tokens_get
      #
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
        client.get("/v3/vault/payment-tokens", query: query, body: body, headers: headers)
      end

      #
      # Retrieve a payment token
      #
      # @see https://developer.paypal.com/docs/api/payment-tokens/v3/#payment-tokens_get
      #
      # @param id [String] ID of the payment token.
      # @macro request
      #
      def show(id, query: nil, body: nil, headers: nil)
        client.get("/v3/vault/payment-tokens/#{encode(id)}", query: query, body: body, headers: headers)
      end

      #
      # Delete payment token
      #
      # @see https://developer.paypal.com/docs/api/payment-tokens/v3/#payment-tokens_delete
      #
      # @param id [String] ID of the payment token
      # @macro request
      #
      def delete(id, query: nil, body: nil, headers: nil)
        client.delete("/v3/vault/payment-tokens/#{encode(id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
