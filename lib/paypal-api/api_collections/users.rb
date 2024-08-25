# frozen_string_literal: true

module PaypalAPI
  #
  # Managing users APIs
  #
  # https://developer.paypal.com/docs/api/identity/v2/
  #
  class Users < APICollection
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
      # Create user
      #
      # @see https://developer.paypal.com/docs/api/identity/v2/#users_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        headers = add_scim_content_type(headers)
        client.post("/v2/scim/Users", query: query, body: body, headers: headers)
      end

      #
      # List users
      #
      # @see https://developer.paypal.com/docs/api/identity/v2/#users_list
      #
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
        headers = add_scim_content_type(headers)
        client.get("/v2/scim/Users", query: query, body: body, headers: headers)
      end

      #
      # Show user details
      #
      # @see https://developer.paypal.com/docs/api/identity/v2/#users_get
      #
      # @param user_id [String] User ID
      # @macro request
      #
      def show(user_id, query: nil, body: nil, headers: nil)
        headers = add_scim_content_type(headers)
        client.get("/v2/scim/Users/#{encode(user_id)}", query: query, body: body, headers: headers)
      end

      #
      # Update user
      #
      # @see https://developer.paypal.com/docs/api/identity/v2/#users_update
      #
      # @param user_id [String] User ID
      # @macro request
      #
      def update(user_id, query: nil, body: nil, headers: nil)
        headers = add_scim_content_type(headers)
        client.patch("/v2/scim/Users/#{encode(user_id)}", query: query, body: body, headers: headers)
      end

      #
      # Delete user
      #
      # @see https://developer.paypal.com/docs/api/identity/v2/#users_delete
      #
      # @param user_id [String] User ID
      # @macro request
      #
      def delete(user_id, query: nil, body: nil, headers: nil)
        headers = add_scim_content_type(headers)
        client.delete("/v2/scim/Users/#{encode(user_id)}", query: query, body: body, headers: headers)
      end

      private

      def add_scim_content_type(headers)
        headers ||= {}
        headers = headers.transform_keys { |key| (key.to_s.downcase == "content-type") ? "content-type" : key }
        headers["content-type"] ||= "application/scim+json"
        headers
      end
    end

    include APIs
    extend APIs
  end
end
