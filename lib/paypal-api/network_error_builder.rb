# frozen_string_literal: true

module PaypalAPI
  #
  # Builds PaypalAPI::NetowrkError error
  #
  class NetworkErrorBuilder
    ERRORS = [
      EOFError,
      Errno::ECONNABORTED,
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Errno::EHOSTUNREACH,
      Errno::EPIPE,
      Errno::ETIMEDOUT,
      IOError,
      OpenSSL::SSL::SSLError,
      SocketError,
      Timeout::Error # Net::OpenTimeout, Net::ReadTimeout
    ].freeze

    class << self
      def call(request:, error:)
        NetworkError.new(error.message, request: request, error: error)
      end
    end
  end
end
