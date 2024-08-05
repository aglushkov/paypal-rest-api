# frozen_string_literal: true

module PaypalAPI
  #
  # PaypalAPI Client
  #
  class Client
    attr_reader :config

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

    def access_token
      (@access_token.nil? || @access_token.expired?) ? refresh_access_token : @access_token
    end

    def refresh_access_token
      response = authorization.generate_access_token

      @access_token = AccessToken.new(
        requested_at: response.requested_at,
        expires_in: response.fetch(:expires_in),
        access_token: response.fetch(:access_token),
        token_type: response.fetch(:token_type)
      )
    end

    def post(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Post, path, query: query, body: body, headers: headers)
    end

    def get(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Get, path, query: query, body: body, headers: headers)
    end

    def patch(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Patch, path, query: query, body: body, headers: headers)
    end

    def put(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Put, path, query: query, body: body, headers: headers)
    end

    def delete(path, query: nil, body: nil, headers: nil)
      execute_request(Net::HTTP::Delete, path, query: query, body: body, headers: headers)
    end

    def authorization
      Authentication.new(self)
    end

    def orders
      Orders.new(self)
    end

    def payments
      Payments.new(self)
    end

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
