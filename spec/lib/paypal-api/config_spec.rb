# frozen_string_literal: true

RSpec.describe PaypalAPI::Config do
  let(:config) do
    described_class.new
  end

  context "with default params" do
    it "generates config" do
      expect(config.http_opts).to eq({})
      expect(config.retries).to eq(enabled: true, count: 4, sleep: [0, 0.25, 0.75, 1.5])
      expect(config).to be_frozen
    end
  end

  context "with custom params" do
    let(:config) do
      described_class.new(
        http_opts: http_opts,
        retries: retries
      )
    end

    let(:http_opts) { {open_timeout: 5, read_timeout: 5} }
    let(:retries) { {enabled: false} }

    it "generates config by merging defaults with provided values" do
      expect(config.http_opts).to eq({open_timeout: 5, read_timeout: 5})
      expect(config.retries).to eq({enabled: false, count: 4, sleep: [0, 0.25, 0.75, 1.5]})
      expect(config).to be_frozen
    end
  end
end
