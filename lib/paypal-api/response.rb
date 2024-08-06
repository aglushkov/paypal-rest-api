# frozen_string_literal: true

require "json"

module PaypalAPI
  #
  # PaypalAPI::Response object
  #
  class Response
    attr_reader :http_response, :requested_at

    #
    # Initializes Response object
    #
    # @param http_response [Net::HTTP::Response] original response
    # @param requested_at [Time] Time when original response was requested
    #
    # @return [Response] Initialized Response object
    #
    def initialize(http_response, requested_at:)
      @requested_at = requested_at
      @http_response = http_response
      @http_status = nil
      @http_headers = nil
      @http_body = nil
      @body = nil
    end

    # Parses JSON body if response body contains JSON or returns original
    # http body string
    #
    # @return [Hash, String] Parsed response body (with symbolized keys)
    def body
      @body ||= json_response? ? parse_json(http_body) : http_body
    end

    # @return [Integer] HTTP status as Integer
    def http_status
      @http_status ||= http_response.code.to_i
    end

    # @return [Hash] HTTP headers as Hash
    def http_headers
      @http_headers ||= http_response.each_header.to_h
    end

    # @return [String] Original http body
    def http_body
      @http_body ||= http_response.body
    end

    # Takes specific key from body, returns nil if key not present in parsed body
    def [](key)
      body[key.to_sym] if body.is_a?(Hash)
    end

    # Fetches specific key from body, raises error if key not exists
    def fetch(key)
      data = body.is_a?(Hash) ? body : {}
      data.fetch(key.to_sym)
    end

    #
    # Instance representation string. Default was overwritten to hide secrets
    #
    def inspect
      "#<#{self.class.name} (#{http_response.code})>"
    end

    private

    def json_response?
      content_type = http_response["content-type"]
      !content_type.nil? && content_type.include?("json")
    end

    def parse_json(json)
      JSON.parse(json, symbolize_names: true)
    rescue JSON::ParserError, TypeError
      json
    end
  end
end
