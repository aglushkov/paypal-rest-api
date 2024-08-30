# frozen_string_literal: true

require "zlib"

module PaypalAPI
  #
  # Webhook Verifier
  # @api private
  #
  class WebhookVerifier
    # Error that can happen when verifying webhook when some required headers are missing
    class MissingHeader < StandardError
    end

    # @return [Client] current client
    attr_reader :client

    def initialize(client)
      @client = client
    end

    # Verifies Webhook.
    #
    # It requires one-time request to download and cache certificate.
    # If local verification returns false it tries to verify webhook online.
    #
    # @param webhook_id [String] Webhook ID provided by PayPal when registering webhook for your URL
    # @param headers [Hash] webhook request headers
    # @param raw_body [String] webhook request raw body string
    #
    # @return [Boolean]
    def call(webhook_id:, headers:, raw_body:)
      args = {
        webhook_id: webhook_id,
        raw_body: raw_body,
        auth_algo: paypal_auth_algo(headers),
        transmission_sig: paypal_transmission_sig(headers),
        transmission_id: paypal_transmission_id(headers),
        transmission_time: paypal_transmission_time(headers),
        cert_url: paypal_cert_url(headers)
      }

      offline(**args) || online(**args)
    end

    private

    def offline(webhook_id:, auth_algo:, transmission_sig:, transmission_id:, transmission_time:, cert_url:, raw_body:)
      return false unless auth_algo.downcase.start_with?("sha256")

      signature = paypal_signature(transmission_sig)
      checked_data = "#{transmission_id}|#{transmission_time}|#{webhook_id}|#{Zlib.crc32(raw_body)}"
      openssl_pub_key = download_and_cache_certificate(cert_url)

      digest = OpenSSL::Digest.new("sha256", signature)
      openssl_pub_key.verify(digest, signature, checked_data)
    end

    def online(webhook_id:, auth_algo:, transmission_sig:, transmission_id:, transmission_time:, cert_url:, raw_body:)
      body = {
        webhook_id: webhook_id,
        auth_algo: auth_algo,
        cert_url: cert_url,
        transmission_id: transmission_id,
        transmission_sig: transmission_sig,
        transmission_time: transmission_time,
        webhook_event: JSON.parse(raw_body)
      }

      response = client.webhooks.verify(body: body)
      response[:verification_status] == "SUCCESS"
    end

    def paypal_signature(transmission_sig)
      transmission_sig.unpack1("m") # decode base64
    end

    def paypal_transmission_sig(headers)
      headers["paypal-transmission-sig"] || (raise MissingHeader, "No `paypal-transmission-sig` header")
    end

    def paypal_transmission_id(headers)
      headers["paypal-transmission-id"] || (raise MissingHeader, "No `paypal-transmission-id` header")
    end

    def paypal_transmission_time(headers)
      headers["paypal-transmission-time"] || (raise MissingHeader, "No `paypal-transmission-time` header")
    end

    def paypal_cert_url(headers)
      headers["paypal-cert-url"] || (raise MissingHeader, "No `paypal-cert-url` header")
    end

    def paypal_auth_algo(headers)
      headers["paypal-auth-algo"] || (raise MissingHeader, "No `paypal-auth-algo` header")
    end

    def download_and_cache_certificate(cert_url)
      client.config.certs_cache.fetch("PaypalRestAPI.certificate.#{cert_url}") do
        client.get(cert_url, headers: {"authorization" => nil}).http_body
      end
    end
  end
end
