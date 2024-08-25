# frozen_string_literal: true

module PaypalAPI
  #
  # Makes payments to multiple PayPal or Venmo recipients
  #
  # @see https://developer.paypal.com/docs/api/payments.payouts-batch/v1/
  #
  class Payouts < APICollection
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
      # Create batch payout
      #
      # @see https://developer.paypal.com/docs/api/payments.payouts-batch/v1/#payouts_post
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/payments/payouts", query: query, body: body, headers: headers)
      end

      #
      # Show payout batch details
      #
      # @see https://developer.paypal.com/docs/api/payments.payouts-batch/v1/#payouts_get
      #
      # @param payout_batch_id [String] The ID of the payout for which to show details.
      # @macro request
      #
      def show(payout_batch_id, query: nil, body: nil, headers: nil)
        client.get("/v1/payments/payouts/#{encode(payout_batch_id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
