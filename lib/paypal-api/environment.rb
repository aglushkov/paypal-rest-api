# frozen_string_literal: true

module PaypalAPI
  # Sandbox API PayPal URL
  SANDBOX_API_URL = "https://api-m.sandbox.paypal.com"

  # Live API PayPal URL
  LIVE_API_URL = "https://api-m.paypal.com"

  # Sandbox PayPal Web URL
  SANDBOX_WEB_URL = "https://sandbox.paypal.com"

  # Live PayPal Web URL
  LIVE_WEB_URL = "https://paypal.com"

  #
  # PayPal environment info
  #
  class Environment
    # PayPal client_id
    attr_accessor :client_id

    # PayPal client_secret
    attr_reader :client_secret

    # PayPal API base URL
    attr_reader :api_url

    # PayPal web URL
    attr_reader :web_url

    # Initializes Environment
    #
    # @param client_id [String] PayPal client id
    # @param client_secret [String] PayPal client secret
    # @param live [Boolean] PayPal live/sandbox mode
    #
    # @return [Client] Initialized config object
    #
    def initialize(client_id:, client_secret:, live: false)
      @live = live || false
      @api_url = live ? LIVE_API_URL : SANDBOX_API_URL
      @web_url = live ? LIVE_WEB_URL : SANDBOX_WEB_URL
      @client_id = client_id
      @client_secret = client_secret
      freeze
    end

    #
    # Instance representation string. Default was overwritten to hide secrets
    # @return [String]
    #
    def inspect
      "#<#{self.class.name} live: #{@live}>"
    end

    alias_method :to_s, :inspect

    #
    # Checks if live environment enabled
    # @return [Boolean]
    #
    def live?
      @live
    end

    #
    # Checks if sandbox environment enabled
    # @return [Boolean]
    #
    def sandbox?
      !live?
    end
  end
end
