# frozen_string_literal: true

module PaypalAPI
  #
  # Use the Payment Experience API to create seamless payment experience profiles.
  #
  # @see https://developer.paypal.com/docs/api/orders/v2/
  #
  class PaymentExperienceWebProfiles < APICollection
    #
    # Common methods for PaypalAPI::PaymentExperienceWebProfiles class and client.orders instance
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # Create web experience profile
      #
      # @see https://developer.paypal.com/docs/api/payment-experience/v1/#web-profile_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/payment-experience/web-profiles", query: query, body: body, headers: headers)
      end

      #
      # List web experience profiles
      #
      # @see https://developer.paypal.com/docs/api/payment-experience/v1/#web-profile_get-list
      #
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
        client.get("/v1/payment-experience/web-profiles", query: query, body: body, headers: headers)
      end

      #
      # Show web experience profile details by ID
      #
      # @see https://developer.paypal.com/docs/api/payment-experience/v1/#web-profile_get
      #
      # @param id [String] The ID of the profile for which to show details.
      # @macro request
      #
      def show(id, query: nil, body: nil, headers: nil)
        client.get("/v1/payment-experience/web-profiles/#{encode(id)}", query: query, body: body, headers: headers)
      end

      #
      # Replace web experience profile
      #
      # @see https://developer.paypal.com/docs/api/payment-experience/v1/#web-profile_update
      #
      # @param id [String] The ID of the profile to replace.
      # @macro request
      #
      def replace(id, query: nil, body: nil, headers: nil)
        client.put("/v1/payment-experience/web-profiles/#{encode(id)}", query: query, body: body, headers: headers)
      end

      #
      # Partially update web experience profile
      #
      # @see https://developer.paypal.com/docs/api/payment-experience/v1/#web-profile_partial-update
      #
      # @param id [String] The ID of the profile to update.
      # @macro request
      #
      def update(id, query: nil, body: nil, headers: nil)
        client.patch("/v1/payment-experience/web-profiles/#{encode(id)}", query: query, body: body, headers: headers)
      end

      #
      # Delete web experience profile
      #
      # @see https://developer.paypal.com/docs/api/payment-experience/v1/#web-profile_delete
      #
      # @param id [String] The ID of the profile to delete.
      # @macro request
      #
      def delete(id, query: nil, body: nil, headers: nil)
        client.delete("/v1/payment-experience/web-profiles/#{encode(id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
