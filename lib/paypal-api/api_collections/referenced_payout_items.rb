# frozen_string_literal: true

module PaypalAPI
  #
  # Enables partner merchants and developers to process individual referenced payouts to recipients.
  #
  # @see https://developer.paypal.com/docs/api/referenced-payouts/v1/
  #
  class ReferencedPayoutItems < APICollection
    #
    # Common methods for PaypalAPI::ReferencedPayoutItems class and client.referenced_payout_items instance
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # Create referenced payout item
      #
      # @see https://developer.paypal.com/docs/api/referenced-payouts/v1/#referenced-payouts-items_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/payments/referenced-payouts-items", query: query, body: body, headers: headers)
      end

      #
      # Show referenced payout item details
      #
      # @see https://developer.paypal.com/docs/api/referenced-payouts/v1/#referenced-payouts-items_get
      #
      # @param payouts_item_id [String] The ID of the referenced payout item for which to show details.
      # @macro request
      #
      def show(payouts_item_id, query: nil, body: nil, headers: nil)
        client.get("/v1/payments/referenced-payouts-items/#{encode(payouts_item_id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
