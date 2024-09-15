# frozen_string_literal: true

module PaypalAPI
  #
  # Payment Setup Tokens
  #
  # @see https://developer.paypal.com/docs/api/payment-tokens/v3/
  #
  class SetupTokens < APICollection
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
      # Create a setup token
      #
      # @see https://developer.paypal.com/docs/api/payment-tokens/v3/#setup-tokens_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v3/vault/setup-tokens", query: query, body: body, headers: headers)
      end

      #
      # Retrieve a setup token
      #
      # @see https://developer.paypal.com/docs/api/payment-tokens/v3/#setup-tokens_get
      #
      # @param id [String] ID of the setup token.
      # @macro request
      #
      def show(id, query: nil, body: nil, headers: nil)
        client.get("/v3/vault/setup-tokens/#{encode(id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
