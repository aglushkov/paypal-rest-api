# frozen_string_literal: true

module PaypalAPI
  #
  # Builds PaypalAPI::NetowrkError error
  #
  class NetworkErrorBuilder
    # List of possible Network errors
    ERRORS = [
      IOError,
      Errno::ECONNABORTED,
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::EHOSTUNREACH,
      Errno::EPIPE,
      Errno::ETIMEDOUT,
      OpenSSL::SSL::SSLError,
      SocketError,
      Timeout::Error # Net::OpenTimeout, Net::ReadTimeout
    ].freeze

    class << self
      # Builds NetworkError instance
      #
      # @param request [Request] Original request
      # @param error [StandardError] Original error
      #
      # @return [Errors::NetworkError] Built NetworkError
      #
      def call(request:, error:)
        Errors::NetworkError.new(error.message, request: request, error: error)
      end
    end
  end
end
