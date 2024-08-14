# frozen_string_literal: true

module PaypalAPI
  #
  # Manages customer disputes
  #
  # @see https://developer.paypal.com/docs/api/orders/v2/
  #
  class Disputes < APICollection
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
      # Appeal dispute
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_appeal
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def appeal(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/appeal", query: query, body: body, headers: headers)
      end

      #
      # Make offer to resolve dispute
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_make-offer
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def make_offer(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/make-offer", query: query, body: body, headers: headers)
      end

      #
      # Show dispute details
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_get
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def show(dispute_id, query: nil, body: nil, headers: nil)
        client.get("/v1/customer/disputes/#{dispute_id}", query: query, body: body, headers: headers)
      end

      #
      # Update dispute
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_patch
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def update(dispute_id, query: nil, body: nil, headers: nil)
        client.patch("/v1/customer/disputes/#{dispute_id}", query: query, body: body, headers: headers)
      end

      #
      # Send message about dispute to other party
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_send-message
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def send_message(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/send-message", query: query, body: body, headers: headers)
      end

      #
      # Provide supporting information for dispute
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_provide-supporting-info
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def provide_supporting_info(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/provide-supporting-info", query: query, body: body, headers: headers)
      end

      #
      # Update dispute status
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_require-evidence
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def update_status(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/require-evidence", query: query, body: body, headers: headers)
      end

      #
      # Deny offer to resolve dispute
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_deny-offer
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def deny_offer(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/deny-offer", query: query, body: body, headers: headers)
      end

      #
      # Provide evidence
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_provide-evidence
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def provide_evidence(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/provide-evidence", query: query, body: body, headers: headers)
      end

      #
      # Settle dispute
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_adjudicate
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def settle(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/adjudicate", query: query, body: body, headers: headers)
      end

      #
      # Acknowledge returned item
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_acknowledge-return-item
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def acknowledge_return_item(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/acknowledge-return-item", query: query, body: body, headers: headers)
      end

      #
      # Accept claim
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_accept-claim
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def accept_claim(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/accept-claim", query: query, body: body, headers: headers)
      end

      #
      # List disputes
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_list
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
        client.get("/v1/customer/disputes", query: query, body: body, headers: headers)
      end

      #
      # Escalate dispute to claim
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_escalate
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def escalate(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/escalate", query: query, body: body, headers: headers)
      end

      #
      # Accept offer to resolve dispute
      #
      # @see https://developer.paypal.com/docs/api/customer-disputes/v1/#disputes_accept-offer
      # @param dispute_id [String] Dispute ID
      # @macro request
      #
      def accept_offer(dispute_id, query: nil, body: nil, headers: nil)
        client.post("/v1/customer/disputes/#{dispute_id}/accept-offer", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
