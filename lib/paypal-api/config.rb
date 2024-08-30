# frozen_string_literal: true

module PaypalAPI
  #
  # Stores configuration for PaypalAPI Client
  #
  class Config
    # Live PayPal URL
    LIVE_URL = "https://api-m.paypal.com"

    # Sandbox PayPal URL
    SANDBOX_URL = "https://api-m.sandbox.paypal.com"

    # Default config options
    DEFAULTS = {
      live: false,
      http_opts: {}.freeze,
      retries: {enabled: true, count: 3, sleep: [0.25, 0.75, 1.5].freeze}.freeze
    }.freeze

    attr_reader :client_id, :client_secret, :live, :http_opts, :retries, :certs_cache

    # Initializes Config
    #
    # @param client_id [String] PayPal client id
    # @param client_secret [String] PayPal client secret
    # @param live [Boolean] PayPal live/sandbox mode
    # @param http_opts [Hash] Net::Http opts for all requests
    # @param retries [Hash] Retries configuration
    # @param cache [#read, nil] Application cache to store certificates to validate webhook events locally.
    #   Must respond to #read(key) and #write(key, expires_in: Integer)
    #
    # @return [Client] Initialized config object
    #
    def initialize(client_id:, client_secret:, live: nil, http_opts: nil, retries: nil, cache: nil)
      @client_id = client_id
      @client_secret = client_secret
      @live = with_default(:live, live)
      @http_opts = with_default(:http_opts, http_opts)
      @retries = with_default(:retries, retries)
      @certs_cache = WebhookVerifier::CertsCache.new(cache)

      freeze
    end

    # @return [String] PayPal live or sandbox URL
    def url
      live ? LIVE_URL : SANDBOX_URL
    end

    #
    # Instance representation string. Default was overwritten to hide secrets
    #
    def inspect
      "#<#{self.class.name} live: #{live}>"
    end

    alias_method :to_s, :inspect

    private

    def with_default(option_name, value)
      default = DEFAULTS.fetch(option_name)

      case value
      when NilClass then default
      when Hash then default.merge(value)
      else value
      end
    end
  end
end
