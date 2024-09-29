# frozen_string_literal: true

module PaypalAPI
  #
  # Use the Transaction Search API to get the history of transactions for a PayPal account.
  #
  # @see https://developer.paypal.com/docs/api/transaction-search/v1/
  #
  class TransactionSearch < APICollection
    #
    # Common methods for PaypalAPI::TransactionSearch class and client.transaction_search instance
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # List transactions
      #
      # @see https://developer.paypal.com/docs/api/transaction-search/v1/#search_get
      #
      # @macro request
      #
      def list_transactions(query: nil, body: nil, headers: nil)
        client.get("/v1/reporting/transactions", query: query, body: body, headers: headers)
      end

      #
      # List all balances
      #
      # @see https://developer.paypal.com/docs/api/transaction-search/v1/#balances_get
      #
      # @macro request
      #
      def list_all_balances(query: nil, body: nil, headers: nil)
        client.get("/v1/reporting/balances", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
