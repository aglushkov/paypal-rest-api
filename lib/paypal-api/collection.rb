# frozen_string_literal: true

module PaypalAPI
  #
  # Base class for all PayPal API collections classes
  #
  class Collection
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def self.client
      PaypalAPI.client
    end
  end
end
