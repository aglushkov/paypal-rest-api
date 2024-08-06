# frozen_string_literal: true

#
# PaypalAPI is a main gem module.
# It can store global PaypalAPI::Client for easier access to APIs.
#
# For example:
#   # setup client in an initializer
#   PaypalAPI.client = PaypalAPI::Client.new(...)
#
#   # And then use anywhere
#   PaypalAPI::Webhooks.list # or PaypalAPI.webhooks.list
#
module PaypalAPI
  class << self
    attr_writer :client

    [:post, :get, :patch, :put, :delete].each do |method_name|
      define_method(method_name) do |path, query: nil, body: nil, headers: nil|
        client.public_send(method_name, path, query: query, body: body, headers: headers)
      end
    end

    %i[
      authorization
      orders
      payments
      webhooks
    ].each do |method_name|
      define_method(method_name) do
        client.public_send(method_name)
      end
    end

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
