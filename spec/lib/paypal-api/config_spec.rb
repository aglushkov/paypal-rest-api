# frozen_string_literal: true

RSpec.describe PaypalAPI::Config do
  let(:client_id) { "CLIENT_ID" }
  let(:client_secret) { "CLIENT_SECRET" }

  let(:config) do
    described_class.new(
      client_id: client_id,
      client_secret: client_secret
    )
  end

  it "does not shows secrets in #inspect and #to_s methods" do
    expect(config.inspect).not_to include client_id
    expect(config.inspect).not_to include client_secret
    expect(config.to_s).not_to include client_id
    expect(config.to_s).not_to include client_secret
  end

  context "with default params" do
    it "generetes config" do
      expect(config.client_id).to eq client_id
      expect(config.client_secret).to eq client_secret
      expect(config.live).to be false
      expect(config.http_opts).to eq(max_retries: 0)
      expect(config.retries).to eq(enabled: true, count: 3, sleep: [0.25, 0.75, 1.5])
      expect(config.url).to eq "https://api-m.sandbox.paypal.com"
      expect(config).to be_frozen
    end
  end

  context "with custom params" do
    let(:config) do
      described_class.new(
        client_id: client_id,
        client_secret: client_secret,
        live: live,
        http_opts: http_opts,
        retries: retries
      )
    end

    let(:live) { true }
    let(:http_opts) { {open_timeout: 5, read_timeout: 5} }
    let(:retries) { {enabled: false} }

    it "generetes config by merging defaults with provided values" do
      expect(config.client_id).to eq client_id
      expect(config.client_secret).to eq client_secret
      expect(config.live).to be true
      expect(config.http_opts).to eq({max_retries: 0, open_timeout: 5, read_timeout: 5})
      expect(config.retries).to eq({enabled: false, count: 3, sleep: [0.25, 0.75, 1.5]})
      expect(config.url).to eq "https://api-m.paypal.com"
      expect(config).to be_frozen
    end
  end
end
