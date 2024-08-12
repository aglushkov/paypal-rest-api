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
end
