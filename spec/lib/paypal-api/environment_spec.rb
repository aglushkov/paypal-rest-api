# frozen_string_literal: true

RSpec.describe PaypalAPI::Environment do
  let(:client_id) { "CLIENT_ID" }
  let(:client_secret) { "CLIENT_SECRET" }
  let(:opts) { {client_id: client_id, client_secret: client_secret} }
  let(:env) { described_class.new(**opts) }

  it "does not shows secrets in #inspect and #to_s methods" do
    expect(env.inspect).not_to include client_id
    expect(env.inspect).not_to include client_secret
    expect(env.to_s).not_to include client_id
    expect(env.to_s).not_to include client_secret
    expect(env).to be_frozen
  end

  context "with no live argument" do
    let(:opts) { {client_id: client_id, client_secret: client_secret} }

    it "constructs SANDBOX environment" do
      expect(env.client_id).to equal client_id
      expect(env.client_secret).to equal client_secret
      expect(env.sandbox?).to be true
      expect(env.live?).to be false
      expect(env.api_url).to eq "https://api-m.sandbox.paypal.com"
      expect(env.web_url).to eq "https://sandbox.paypal.com"
    end
  end

  context "with live:false argument" do
    let(:opts) { {client_id: client_id, client_secret: client_secret, live: false} }

    it "constructs SANDBOX environment" do
      expect(env.client_id).to equal client_id
      expect(env.client_secret).to equal client_secret
      expect(env.sandbox?).to be true
      expect(env.live?).to be false
      expect(env.api_url).to eq "https://api-m.sandbox.paypal.com"
      expect(env.web_url).to eq "https://sandbox.paypal.com"
    end
  end

  context "with live:true argument" do
    let(:opts) { {client_id: client_id, client_secret: client_secret, live: true} }

    it "constructs LIVE environment" do
      expect(env.client_id).to equal client_id
      expect(env.client_secret).to equal client_secret
      expect(env.sandbox?).to be false
      expect(env.live?).to be true
      expect(env.api_url).to eq "https://api-m.paypal.com"
      expect(env.web_url).to eq "https://paypal.com"
    end
  end
end
