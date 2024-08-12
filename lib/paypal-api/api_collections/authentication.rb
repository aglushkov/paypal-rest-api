# frozen_string_literal: true

module PaypalAPI
  #
  # Authentication APIs collection
  #
  # @see https://developer.paypal.com/api/rest/authentication/
  #
  class Authentication < APICollection
    #
    # Generate access-token API request path
    #
    PATH = "/v1/oauth2/token"

    #
    # Common class and instance methods
    #
    module APIs
      #
      # Generates access token.
      #
      # @see https://developer.paypal.com/api/rest/authentication/
      #
      # Default headers are:
      #   { "content-type" => "application/x-www-form-urlencoded", "authorization" => "Basic <TOKEN>" }
      #
      # Default body is:
      #   {grant_type: "client_credentials"}
      #
      # @example
      #   PaypalAPI::Authentication.generate_access_token
      #   PaypalAPI.client.authorization.generate_access_token # same
      #
      # @param query [Hash, nil] Request query string parameters
      # @param body [Hash, nil] Request body parameters
      # @param headers [Hash, nil] Request headers
      #
      # @raise [Error] on network error or non 2** status code returned from PayPal
      # @return [Response] detailed http request-response representation
      #
      def generate_access_token(query: nil, body: nil, headers: nil)
        body ||= {grant_type: "client_credentials"}

        default_headers = {
          "content-type" => "application/x-www-form-urlencoded",
          "authorization" => "Basic #{["#{client.config.client_id}:#{client.config.client_secret}"].pack("m0")}"
        }

        client.post(PATH, query: query, body: body, headers: merge_headers!(default_headers, headers))
      end

      private

      def merge_headers!(headers, other_headers)
        return headers unless other_headers

        other_headers = other_headers.transform_keys { |key| key.to_s.downcase }
        headers.merge!(other_headers)
      end
    end

    include APIs
    extend APIs
  end
end
