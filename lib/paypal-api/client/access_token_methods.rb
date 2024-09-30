# frozen_string_literal: true

module PaypalAPI
  class Client
    #
    # Client methods to get access token
    #
    module AccessTokenMethods
      #
      # Checks cached access token is expired and returns it or generates new one
      #
      # @return [AccessToken] AccessToken object
      #
      def access_token
        (@access_token.nil? || @access_token.expired?) ? refresh_access_token : @access_token
      end

      #
      # Generates and caches new AccessToken
      #
      # @return [AccessToken] new AccessToken object
      #
      def refresh_access_token
        requested_at = Time.now
        response = authentication.generate_access_token

        @access_token = AccessToken.new(
          requested_at: requested_at,
          expires_in: response.fetch(:expires_in),
          access_token: response.fetch(:access_token),
          token_type: response.fetch(:token_type)
        )
      end
    end
  end
end
