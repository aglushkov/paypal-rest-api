# frozen_string_literal: true

require "json"

module PaypalAPI
  #
  # PaypalAPI::Response object
  #
  class Response
    # List of Net::HTTP responses that can be retried
    RETRYABLE_RESPONSES = [
      Net::HTTPServerError,    # 5xx
      Net::HTTPConflict,       # 409
      Net::HTTPTooManyRequests # 429
    ].freeze

    # @return [Net::HTTP::Response] Original Net::HTTP::Response object
    attr_reader :http_response

    # @return [Request] Request object
    attr_reader :request

    #
    # Initializes Response object
    #
    # @param http_response [Net::HTTP::Response] original response
    # @param request [Request] Request that generates this response
    #
    # @return [Response] Initialized Response object
    #
    def initialize(http_response, request:)
      @request = request
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

    # Checks http status code is 2xx
    #
    # @return [Boolean] Returns true if response has success status code (2xx)
    def success?
      http_response.is_a?(Net::HTTPSuccess)
    end

    # Checks http status code is not 2xx
    #
    # @return [Boolean] Returns true if response has not success status code
    def failed?
      !success?
    end

    # Checks if response status code is retriable (5xx, 409, 429)
    # @api private
    #
    # @return [Boolean] Returns true if status code is retriable (5xx, 409, 429)
    def retryable?
      failed? && RETRYABLE_RESPONSES.any? { |retryable_class| http_response.is_a?(retryable_class) }
    end

    # Checks if response status code is unauthorized (401)
    # @api private
    #
    # @return [Boolean] Returns true if status code is retriable (5xx, 409, 429)
    def unauthorized?
      http_response.is_a?(Net::HTTPUnauthorized)
    end

    #
    # Instance representation string. Default was overwritten to hide secrets
    #
    def inspect
      "#<#{self.class.name} (#{http_response.code})>"
    end

    #
    # Follow up HATEOAS link
    #
    # @see https://developer.paypal.com/api/rest/responses/#link-hateoaslinks
    #
    # @param rel [String] Target link "rel" attribute
    # @param query [Hash] Request additional query parameters
    # @param body [Hash] Request body parameters
    # @param headers [Hash] Request headers
    #
    # @return [Response, nil] Follow-up link response, if link with provided "rel" exists
    #
    def follow_up_link(rel, query: nil, body: nil, headers: nil)
      links = self[:links]
      return unless links

      link = links.find { |curr_link| curr_link[:rel] == rel.to_s }
      return unless link

      http_method = link[:method]&.downcase || :get
      request.client.public_send(http_method, link[:href], query: query, body: body, headers: headers)
    end

    #
    # Pagination methods
    #
    module PaginationHelpers
      #
      # Iterates through all response pages by requesting HATEOAS "next" links,
      # making additional fetches to the API as necessary.
      #
      # @see #follow_up_link
      #
      # @yield [Response] Next page response
      #
      # @return [void]
      #
      def each_page(&block)
        return enum_for(:each_page) unless block

        page = self

        loop do
          yield(page)
          page = page.follow_up_link("next")
          break unless page
        end
      end

      #
      # Iterates through all items in response +items_field_name+ field,
      # making additional pages requests as necessary.
      #
      # @see #each_page
      #
      # @param items_field_name [Symbol] Name of field containing items
      #
      # @yield [Hash] Item
      #
      # @return [void]
      #
      def each_page_item(items_field_name, &block)
        return enum_for(:each_page_item, items_field_name) unless block

        each_page do |page|
          page.fetch(items_field_name).each(&block)
        end
      end
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

    include PaginationHelpers
  end
end
