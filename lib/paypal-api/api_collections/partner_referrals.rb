# frozen_string_literal: true

module PaypalAPI
  #
  # Use the Partner Referrals API to add PayPal seller accounts to PayPal
  # Complete Payments Platform for Marketplaces and Platforms.
  #
  # @see https://developer.paypal.com/docs/api/partner-referrals/v2/
  #
  class PartnerReferrals < APICollection
    #
    # Common methods for PaypalAPI::PartnerReferrals class and client.partner_referrals instance
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # Create partner referral
      #
      # @see https://developer.paypal.com/docs/api/partner-referrals/v2/#partner-referrals_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v2/customer/partner-referrals", query: query, body: body, headers: headers)
      end

      #
      # Show referral data
      #
      # @see https://developer.paypal.com/docs/api/partner-referrals/v2/#partner-referrals_read
      #
      # @param id [String] The ID of the partner-referrals data for which to show details
      # @macro request
      #
      def show(partner_referral_id, query: nil, body: nil, headers: nil)
        client.get("/v2/customer/partner-referrals/#{encode(partner_referral_id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
