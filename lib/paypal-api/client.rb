# frozen_string_literal: true

module PaypalAPI
  #
  # PaypalAPI Client
  #
  class Client
    attr_reader :config

    # Initializes Client
    #
    # @param client_id [String] PayPal client id
    # @param client_secret [String] PayPal client secret
    # @param live [Boolean] PayPal live/sandbox mode
    # @param http_opts [Hash] Net::Http opts for all requests
    # @param retries [Hash] Retries configuration
    #
    # @return [Client] Initialized client
    #
    def initialize(client_id:, client_secret:, live: nil, http_opts: nil, retries: nil)
      @config = PaypalAPI::Config.new(
        client_id: client_id,
        client_secret: client_secret,
        live: live,
        http_opts: http_opts,
        retries: retries
      )

      @access_token = nil
    end

    #
    # Checks cached access token is expired and returns it or generates new one
    #
    # @return [AccessToken] AccessToken object
    #
    def access_token
      (@access_token.nil? || @access_token.expired?) ? refresh_access_token : @access_token
    end

    #
    # Generates and caches new AccessToken
    #
    # @return [AccessToken] new AccessToken object
    #
    def refresh_access_token
      response = authentication.generate_access_token

      @access_token = AccessToken.new(
        requested_at: response.requested_at,
        expires_in: response.fetch(:expires_in),
        access_token: response.fetch(:access_token),
        token_type: response.fetch(:token_type)
      )
    end

    # @!macro [new] request
    # @param path [String] Request path
    # @param query [Hash, nil] Request query parameters
    # @param body [Hash, nil] Request body parameters
    # @param headers [Hash, nil] Request headers
    #
    # @return [Response] Response object

    #
    # Executes POST http request
    #
    # @macro request
    #
    def post(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Post, path, query: query, body: body, headers: headers)
    end

    #
    # Executes GET http request
    #
    # @macro request
    #
    def get(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Get, path, query: query, body: body, headers: headers)
    end

    #
    # Executes PATCH http request
    #
    # @macro request
    #
    def patch(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Patch, path, query: query, body: body, headers: headers)
    end

    #
    # Executes PUT http request
    #
    # @macro request
    #
    def put(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Put, path, query: query, body: body, headers: headers)
    end

    #
    # Executes DELETE http request
    #
    # @macro request
    #
    def delete(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Delete, path, query: query, body: body, headers: headers)
    end

    # @return [Authentication] Authentication APIs collection
    def authentication
      Authentication.new(self)
    end

    # @return [Orders] Orders APIs collection
    def orders
      Orders.new(self)
    end

    # @return [Payments] Payments APIs collection
    def payments
      Payments.new(self)
    end

    # @return [Webhooks] Webhooks APIs collection
    def webhooks
      Webhooks.new(self)
    end

    private

    def execute_request(http_method, path, query: nil, body: nil, headers: nil)
      request = Request.new(self, http_method, path, query: query, body: body, headers: headers)
      RequestExecutor.call(request)
    end
  end
end
