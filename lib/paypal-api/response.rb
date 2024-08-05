# frozen_string_literal: true

require "json"

module PaypalAPI
  #
  # PaypalAPI::Response object
  #
  class Response
    attr_reader :http_response, :requested_at

    def initialize(http_response, requested_at:)
      @requested_at = requested_at
      @http_response = http_response
      @http_status = nil
      @http_headers = nil
      @http_body = nil
      @body = nil
    end

    def body
      @body ||= json_response? ? parse_json(http_body) : http_body
    end

    def http_status
      @http_status ||= http_response.code.to_i
    end

    def http_headers
      @http_headers ||= http_response.each_header.to_h
    end

    def http_body
      @http_body ||= http_response.body
    end

    def [](key)
      body[key.to_sym] if body
    end

    def fetch(key)
      data = body || {}
      data.fetch(key.to_sym)
    end

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
