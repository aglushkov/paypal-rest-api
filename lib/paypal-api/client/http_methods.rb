# frozen_string_literal: true

module PaypalAPI
  class Client
    #
    # Client HTTP methods
    #
    module HTTPMethods
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

      private

      def execute_request(http_method, path, query: nil, body: nil, headers: nil)
        request = Request.new(self, http_method, path, query: query, body: body, headers: headers)
        RequestExecutor.new(self, request).call
      end
    end
  end
end
