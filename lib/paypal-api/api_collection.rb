# frozen_string_literal: true

require "uri"

module PaypalAPI
  #
  # Base class for all PayPal API collections classes
  #
  class APICollection
    # @return current client
    attr_reader :client

    # Initializes API collection
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

    # Encodes URI component
    # @param id [String] Unencoded URI component
    # @return [String] Encoded URI component
    def encode(id)
      self.class.encode(id)
    end

    # :nocov:
    if URI.respond_to?(:encode_uri_component)
      # Encodes URI component
      # @param id [String] Unencoded URI component
      # @return [String] Encoded URI component
      def self.encode(id)
        URI.encode_uri_component(id)
      end
    else
      # Encodes URI component
      # @param id [String] Unencoded URI component
      # @return [String] Encoded URI component
      def self.encode(id)
        encoded_id = URI.encode_www_form_component(id)
        encoded_id.gsub!("+", "%20")
        encoded_id
      end
    end
    # :nocov:
  end
end
