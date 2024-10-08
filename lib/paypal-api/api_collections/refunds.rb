# frozen_string_literal: true

module PaypalAPI
  #
  # Refunds APIs `/v2/payments/refunds`
  #
  # @see https://developer.paypal.com/docs/api/payments/v2
  #
  class Refunds < APICollection
    #
    # Common methods for PaypalAPI::Refunds class and client.refunds instance
    #
    module APIs
      #
      # Show refund details
      #
      # @see https://developer.paypal.com/docs/api/payments/v2/#refunds_get
      #
      # @param refund_id [String]
      # @macro request
      #
      def show(refund_id, query: nil, body: nil, headers: nil)
        client.get("/v2/payments/refunds/#{encode(refund_id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
