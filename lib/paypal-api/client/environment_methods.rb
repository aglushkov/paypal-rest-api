# frozen_string_literal: true

module PaypalAPI
  class Client
    #
    # Client environment specific methods
    #
    module EnvironmentMethods
      # Checks if PayPal LIVE environment enabled
      # @return [Boolean] Checks if PayPal LIVE environment enabled
      def live?
        env.live?
      end

      # Checks if PayPal SANDBOX environment enabled
      # @return [Boolean] Checks if PayPal SANDBOX environment enabled
      def sandbox?
        env.sandbox?
      end

      # Base API URL
      # @return [String] Base API URL
      def api_url
        env.api_url
      end

      # Base WEB URL
      # @return [String] Base WEB URL
      def web_url
        env.web_url
      end
    end
  end
end
