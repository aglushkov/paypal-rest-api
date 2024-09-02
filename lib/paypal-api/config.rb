# frozen_string_literal: true

module PaypalAPI
  #
  # Stores client requests configuration
  #
  class Config
    # Default config options
    DEFAULTS = {
      http_opts: {}.freeze,
      retries: {enabled: true, count: 4, sleep: [0, 0.25, 0.75, 1.5].freeze}.freeze
    }.freeze

    attr_reader :http_opts, :retries, :certs_cache

    # Initializes Config
    #
    # @param http_opts [Hash] Net::Http opts for all requests
    # @param retries [Hash] Retries configuration
    # @param cache [#read, nil] Application cache to store certificates to validate webhook events locally.
    #   Must respond to #fetch(key, &block)
    #
    # @return [Client] Initialized config object
    #
    def initialize(http_opts: nil, retries: {}, cache: nil)
      @http_opts = http_opts || DEFAULTS[:http_opts]
      @retries = DEFAULTS[:retries].merge(retries || {})
      @certs_cache = WebhookVerifier::CertsCache.new(cache)

      freeze
    end
  end
end
