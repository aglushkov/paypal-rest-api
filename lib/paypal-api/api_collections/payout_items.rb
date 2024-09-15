# frozen_string_literal: true

module PaypalAPI
  #
  # Makes payments to multiple PayPal or Venmo recipients
  #
  # @see https://developer.paypal.com/docs/api/payments.payouts-batch/v1/
  #
  class PayoutItems < APICollection
    #
    # Common methods for PaypalAPI::PayoutItems class and client.payout_items instance
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # Cancel unclaimed payout item
      #
      # @see https://developer.paypal.com/docs/api/payments.payouts-batch/v1/#payouts-item_cancel
      # @param payout_item_id [String] The ID of the payout item to cancel
      # @macro request
      #
      def cancel(payout_item_id, query: nil, body: nil, headers: nil)
        client.post("/v1/payments/payouts-item/#{encode(payout_item_id)}/cancel", query: query, body: body, headers: headers)
      end

      #
      # Show payout item details
      #
      # @see https://developer.paypal.com/docs/api/payments.payouts-batch/v1/#payouts-item_get
      #
      # @param payout_item_id [String] The ID of the payout item
      # @macro request
      #
      def show(payout_item_id, query: nil, body: nil, headers: nil)
        client.get("/v1/payments/payouts-item/#{encode(payout_item_id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
