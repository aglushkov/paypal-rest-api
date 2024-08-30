# frozen_string_literal: true

RSpec.describe PaypalAPI::WebhookVerifier do
  subject(:verify) { described_class.new(client).call(webhook_id: webhook_id, headers: headers, raw_body: raw_body) }

  let(:key) { OpenSSL::PKey::RSA.new(512) }
  let(:cert_digest) { OpenSSL::Digest.new("SHA256") }
  let(:cert) do
    name = OpenSSL::X509::Name.parse("/CN=nobody")
    cert = OpenSSL::X509::Certificate.new
    cert.version = 2
    cert.serial = 0
    cert.not_before = Time.now
    cert.not_after = Time.now
    cert.public_key = key.public_key
    cert.subject = name
    cert.issuer = name
    cert.sign(key, cert_digest)
    cert
  end

  let(:headers) do
    {
      "paypal-auth-algo" => auth_algo,
      "paypal-cert-url" => cert_url,
      "paypal-transmission-id" => transmission_id,
      "paypal-transmission-sig" => transmission_sig,
      "paypal-transmission-time" => transmission_time
    }
  end

  let(:auth_algo) { "SHA256withRSA" }
  let(:cert_url) { "https://api.sandbox.paypal.com/v1/notifications/certs/CERT-360caa42-fca2a594-ab66f33d" }
  let(:transmission_id) { "TID" }
  let(:transmission_time) { "TTIME" }
  let(:webhook_id) { "WEBHOOK_ID" }
  let(:raw_body) { '{"Sign":"me!"}' }
  let(:document) { "#{transmission_id}|#{transmission_time}|#{webhook_id}|#{Zlib.crc32(raw_body)}" }
  let(:transmission_sig) { [key.sign(cert_digest, document)].pack("m") } # encode to Base64

  let(:client) { PaypalAPI::Client.new(client_id: "X", client_secret: "X") }

  context "when offline validation is valid" do
    before do
      stub_request(:get, cert_url).to_return(status: 200, body: cert.to_pem)
    end

    it "returns true" do
      expect(verify).to be true
    end
  end

  context "when offline validation is invalid" do
    let(:auth_algo) { "UNKNOWN_ALGO" }

    before do
      # Stub authorization request
      stub_request(:post, /token/).to_return(
        status: 200,
        body: {expires_in: 100, access_token: "abc", token_type: "Bearer"}.to_json,
        headers: {"content-type" => "application/json"}
      )

      # Stub online verify request
      stub_request(:post, /verify-webhook-signature/).to_return(
        status: 200,
        body: {verification_status: verification_status}.to_json,
        headers: {"content-type" => "application/json"}
      )
    end

    context "when online verification succeeded" do
      let(:verification_status) { "SUCCESS" }

      it "returns true" do
        expect(verify).to be true
      end
    end

    context "when online verification failures" do
      let(:verification_status) { "FAILURE" }

      it "returns false" do
        expect(verify).to be false
      end
    end
  end
end
