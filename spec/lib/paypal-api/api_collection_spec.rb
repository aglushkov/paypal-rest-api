# frozen_string_literal: true

RSpec.describe PaypalAPI::APICollection do
  let(:client) { "CLIENT" }
  let(:resource) { described_class.new(client) }

  describe "#client" do
    it "returns initialization var" do
      expect(resource.client).to equal client
    end
  end

  describe ".client" do
    before { PaypalAPI.client = client }
    after { PaypalAPI.client = nil }

    it "returns client stored in PaypalAPI" do
      expect(described_class.client).to equal client
    end
  end

  describe "#encode" do
    it "encodes URI component" do
      expect(resource.encode("a b")).to eq "a%20b"
      expect(resource.encode("a/b")).to eq "a%2Fb"
    end
  end

  describe ".encode" do
    it "encodes URI component" do
      expect(described_class.encode("a b")).to eq "a%20b"
      expect(described_class.encode("a/b")).to eq "a%2Fb"
    end
  end
end
