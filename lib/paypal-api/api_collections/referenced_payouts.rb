# frozen_string_literal: true

module PaypalAPI
  #
  # The Referenced Payouts API enables partner merchants and developers to process individual referenced payouts to recipients.
  #
  # @see https://developer.paypal.com/docs/api/referenced-payouts/v1/
  #
  class ReferencedPayouts < APICollection
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
      # Create referenced batch payout
      #
      # @see https://developer.paypal.com/docs/api/referenced-payouts/v1/#referenced-payouts_create_batch
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/payments/referenced-payouts", query: query, body: body, headers: headers)
      end

      #
      # List items in referenced batch payout
      #
      # @see https://developer.paypal.com/docs/api/payments.payouts-batch/v1/#payouts_get
      #
      # @param payout_batch_id [String] The ID of the reference batch payout for which to list items.
      # @macro request
      #
      def show(payout_batch_id, query: nil, body: nil, headers: nil)
        client.get("/v1/payments/referenced-payouts/#{encode(payout_batch_id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
