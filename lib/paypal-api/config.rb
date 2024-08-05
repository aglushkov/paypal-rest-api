# frozen_string_literal: true

module PaypalAPI
  LIVE_URL = "https://api-m.paypal.com"
  SANDBOX_URL = "https://api-m.sandbox.paypal.com"

  DEFAULTS = {
    live: false,
    http_opts: {max_retries: 0}.freeze, # we have custo mretries config
    retries: {enabled: true, count: 3, sleep: [0.25, 0.75, 1.5].freeze}.freeze
  }.freeze

  #
  # Stores configuration for PaypalAPI Client
  #
  class Config
    attr_reader :client_id, :client_secret, :live, :http_opts, :retries

    def initialize(client_id:, client_secret:, live: nil, http_opts: nil, retries: nil)
      @client_id = client_id
      @client_secret = client_secret
      @live = with_default(:live, live)
      @http_opts = with_default(:http_opts, http_opts)
      @retries = with_default(:retries, retries)
      freeze
    end

    def url
      live ? LIVE_URL : SANDBOX_URL
    end

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
