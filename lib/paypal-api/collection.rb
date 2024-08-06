# frozen_string_literal: true

module PaypalAPI
  #
  # Base class for all PayPal API collections classes
  #
  class Collection
    # @return current client
    attr_reader :client

    # Initializes APIs collection
    #
    # @param client [Client] current client
    #
    # @return [Collection] APIs collection
    #
    def initialize(client)
      @client = client
    end

    # @return global client
    def self.client
      PaypalAPI.client
    end
  end
end
