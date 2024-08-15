# frozen_string_literal: true

module PaypalAPI
  #
  # Shows OpenID Connect user profile information
  #
  # @see https://developer.paypal.com/docs/api/identity/v1/
  #
  class UserInfo < APICollection
    #
    # Common class and instance methods
    #
    module APIs
      # @!macro [new] request

      #
      # Show user profile details
      #
      # @see https://developer.paypal.com/docs/api/identity/v1/#userinfo_get
      #
      # @param query [Hash, nil] Request query parameters
      # @param body [Hash, nil] Request body parameters
      # @param headers [Hash, nil] Request headers
      # @return [Response] Response object
      #
      def show(query: nil, body: nil, headers: nil)
        query = add_schema_param(query)

        client.get("/v1/identity/openidconnect/userinfo", query: query, body: body, headers: headers)
      end

      private

      def add_schema_param(query)
        return query if query.is_a?(Hash) && (query.key?(:schema) || query.key?("schema"))

        defaults = {schema: "openid"}
        return defaults unless query

        query.merge(defaults)
      end
    end

    include APIs
    extend APIs
  end
end
