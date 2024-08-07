# frozen_string_literal: true

#
# PaypalAPI is a main gem module.
#
# It can store global PaypalAPI::Client for easier access to APIs.
#
# @example Initializing new global client
#   PaypalAPI.client = PaypalAPI::Client.new(
#     client_id: ENV.fetch('PAYPAL_CLIENT_ID'),
#     client_secret: ENV.fetch('PAYPAL_CLIENT_SECRET'),
#     live: false
#   )
#
#   # And then call any APIs without mentioning the client
#   PaypalAPI::Webhooks.list # or PaypalAPI.webhooks.list
#
module PaypalAPI
  class << self
    # Sets client
    attr_writer :client

    # @!macro [new] request
    #
    #   @param path [String] Request path
    #   @param query [Hash, nil] Request query parameters
    #   @param body [Hash, nil] Request body parameters
    #   @param headers [Hash, nil] Request headers
    #
    #   @return [Response] Response object
    #

    # @!method post(path, query: nil, body: nil, headers: nil)
    #
    #   Executes POST http request
    #   @macro request
    #
    # @!method get(path, query: nil, body: nil, headers: nil)
    #
    #   Executes GET http request
    #   @macro request
    #
    # @!method patch(path, query: nil, body: nil, headers: nil)
    #
    #   Executes PATCH http request
    #   @macro request
    #
    # @!method put(path, query: nil, body: nil, headers: nil)
    #
    #   Executes PUT http request
    #   @macro request

    # @!method delete(path, query: nil, body: nil, headers: nil)
    #
    #   Executes DELETE http request
    #   @macro request
    #
    [:post, :get, :patch, :put, :delete].each do |method_name|
      define_method(method_name) do |path, query: nil, body: nil, headers: nil|
        client.public_send(method_name, path, query: query, body: body, headers: headers)
      end
    end

    #
    # @!method authentication
    #   @return [Authentication]
    #
    # @!method orders
    #   @return [Orders]
    #
    # @!method payments
    #   @return [Payments]
    #
    # @!method webhooks
    #   @return [Webhooks]
    #
    %i[
      authentication
      orders
      payments
      webhooks
    ].each do |method_name|
      define_method(method_name) do
        client.public_send(method_name)
      end
    end

    # Globally set Client object
    def client
      raise "#{name}.client must be set" unless @client

      @client
    end
  end
end

require_relative "paypal-api/access_token"
require_relative "paypal-api/client"
require_relative "paypal-api/collection"
require_relative "paypal-api/config"
require_relative "paypal-api/error"
require_relative "paypal-api/failed_request_error_builder"
require_relative "paypal-api/network_error_builder"
require_relative "paypal-api/request"
require_relative "paypal-api/request_executor"
require_relative "paypal-api/response"
require_relative "paypal-api/collections/authentication"
require_relative "paypal-api/collections/orders"
require_relative "paypal-api/collections/payments"
require_relative "paypal-api/collections/webhooks"
