# frozen_string_literal: true

require "securerandom"
require "json"

module PaypalAPI
  #
  # Builds PaypalAPI::Request:
  # - assigns query params
  # - assigns body params
  # - assigns Authentication header
  # - assigns paypal-request-id header
  # - assigns content-type header
  #
  class Request
    # @return [Client] Current PaypalAPI Client
    attr_reader :client

    # @return [Net::HTTPRequest] Generated Net::HTTPRequest
    attr_reader :http_request

    # @return [Time, nil] Time when request was sent
    attr_accessor :requested_at

    # rubocop:disable Metrics/ParameterLists

    # Initializes Request object
    #
    # @param client [Client] PaypalAPI client
    # @param request_type [Class] One of: Net::HTTP::Post, Net::HTTP::Get,
    #  Net::HTTP::Put, Net::HTTP::Patch, Net::HTTP::Delete
    # @param path [String] Request path
    #
    # @param query [Hash, nil] Request query
    # @param body [Hash, nil] Request body
    # @param headers [Hash, nil] Request headers
    #
    # @return [Request] Request object
    #
    def initialize(client, request_type, path, body: nil, query: nil, headers: nil)
      @client = client
      @http_request = build_http_request(request_type, path, body: body, query: query, headers: headers)
      @requested_at = nil
    end
    # rubocop:enable Metrics/ParameterLists

    private

    def build_http_request(request_type, path, body:, query:, headers:)
      uri = request_uri(path, query)
      http_request = request_type.new(uri)

      add_headers(http_request, headers || {})
      add_body(http_request, body)

      http_request
    end

    def add_headers(http_request, headers)
      headers.each { |key, value| http_request[key] = value }

      http_request["content-type"] ||= "application/json"
      http_request["authorization"] ||= client.access_token.authorization_string
      http_request["paypal-request-id"] ||= SecureRandom.uuid if idempotent?(http_request)
    end

    def add_body(http_request, body)
      return unless body

      json?(http_request) ? http_request.body = JSON.dump(body) : http_request.set_form_data(body)
    end

    def request_uri(path, query)
      uri = URI.join(client.config.url, path)
      uri.query = URI.encode_www_form(query) if query && !query.empty?
      uri
    end

    def idempotent?(http_request)
      http_request.method != Net::HTTP::Get::METHOD
    end

    def json?(http_request)
      http_request["content-type"].include?("json")
    end
  end
end
