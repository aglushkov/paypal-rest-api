# frozen_string_literal: true

module PaypalAPI
  class WebhookVerifier
    #
    # Stores certifiactes in-memory.
    #
    # New values are added to this in-memory cache and application cache.
    # When fetching value it firstly looks to the memory cache and then to the app cache.
    #
    # @api private
    #
    class CertsCache
      # Current application cache
      # @api private
      attr_reader :app_cache

      # Hash storage of certificate public keys
      # @api private
      attr_reader :storage

      # Initializes certificates cache
      #
      # @param app_cache [#fetch, nil] Application cache that can store
      #   certificates between redeploys
      #
      # @return [CertsCache]
      def initialize(app_cache)
        @app_cache = app_cache || NullCache
        @storage = {}
      end

      # Fetches value from cache
      #
      # @param key [String] Cache key
      # @param block [Proc] Proc to fetch certificate text
      #
      # @return [OpenSSL::PKey::PKey] Certificate Public Key
      def fetch(key, &block)
        openssl_pub_key = read(key)
        return openssl_pub_key if openssl_pub_key

        cert_string = app_cache.fetch(key, &block)
        cert = OpenSSL::X509::Certificate.new(cert_string)

        write(key, cert.public_key)
      end

      private

      def write(key, value)
        storage[key] = value
      end

      def read(key)
        storage[key]
      end
    end

    #
    # Null-object cache class.
    # Implements only #read and #write method.
    #
    # @api private
    #
    class NullCache
      # Just calls provided block
      # @param _key [String] Cache key
      # @return [String] block result
      def self.fetch(_key)
        yield
      end
    end
  end
end
