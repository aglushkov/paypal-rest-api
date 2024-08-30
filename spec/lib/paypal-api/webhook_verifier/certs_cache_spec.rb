# frozen_string_literal: true

RSpec.describe PaypalAPI::WebhookVerifier::CertsCache do
  let(:cert) do
    key = OpenSSL::PKey::RSA.new(512)
    cert_digest = OpenSSL::Digest.new("SHA256")
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

  let(:cert_string) { cert.to_pem }
  let(:cache) { described_class.new(nil) }
  let(:cache_key) { "foo" }
  let(:public_key) { cert.public_key }

  def match_public_key(cert)
    satisfy("be a public key") { |value| value.export == cert.public_key.export }
  end

  describe "#fetch" do
    context "with existing info" do
      before { cache.storage[cache_key] = public_key }

      it "finds existing information" do
        expect(cache.fetch(cache_key)).to equal public_key
      end
    end

    context "with cert string in app_cache" do
      before { allow(cache.app_cache).to receive(:fetch).and_return(cert_string) }

      it "constructs cert public_key" do
        expect(cache.fetch(cache_key)).to match_public_key(cert)
        expect(cache.app_cache).to have_received(:fetch).with(cache_key)
      end
    end

    context "with no data in cache" do
      it "constructs cert public_key from block" do
        expect(cache.fetch(cache_key) { cert_string }).to match_public_key(cert)
      end
    end
  end
end
