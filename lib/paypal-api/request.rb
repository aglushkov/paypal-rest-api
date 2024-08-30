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

    # @return [Hash, nil, Object] Custom context that can be set/changed in callbacks
    attr_accessor :context

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
      @context = nil
    end
    # rubocop:enable Metrics/ParameterLists

    # @return [String] HTTP request method name
    def method
      http_request.method
    end

    # @return [String] HTTP request method name
    def path
      http_request.path
    end

    # @return [URI] HTTP request URI
    def uri
      http_request.uri
    end

    # @return [String] HTTP request body
    def body
      http_request.body
    end

    # @return [Hash] HTTP request headers
    def headers
      http_request.each_header.to_h
    end

    private

    def build_http_request(request_type, path, body:, query:, headers:)
      uri = build_http_uri(path, query)
      http_request = request_type.new(uri, "accept-encoding" => nil)

      build_http_headers(http_request, body, headers || {})
      build_http_body(http_request, body)

      http_request
    end

    def build_http_headers(http_request, body, headers)
      headers = normalize_headers(headers)

      unless headers.key?("authorization")
        http_request["authorization"] = client.access_token.authorization_string
      end

      unless headers.key?("content-type")
        http_request["content-type"] = "application/json" if body
      end

      unless headers.key?("paypal-request-id")
        http_request["paypal-request-id"] = SecureRandom.uuid unless http_request.is_a?(Net::HTTP::Get)
      end

      headers.each { |key, value| http_request[key] = value }
    end

    def build_http_body(http_request, body)
      return unless body

      is_json = http_request["content-type"].include?("json")
      is_json ? http_request.body = JSON.dump(body) : http_request.set_form_data(body)
    end

    def build_http_uri(path, query)
      uri = URI.join(client.config.url, path)
      uri.query = URI.encode_www_form(query) if query && !query.empty?
      uri
    end

    def normalize_headers(headers)
      headers.empty? ? headers : headers.transform_keys { |key| key.to_s.downcase }
    end
  end
end
