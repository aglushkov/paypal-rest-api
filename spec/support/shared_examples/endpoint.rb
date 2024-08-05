# frozen_string_literal: true

RSpec.shared_examples "endpoint" do |http_method:, path:, api_method:, path_args: {}|
  path = format(path, path_args)

  describe "#{described_class}##{api_method}" do
    let(:client) { instance_double(PaypalAPI::Client, http_method => "RESPONSE") }
    let(:resource) { described_class.new(client) }

    it "calls client with correct args" do
      expect(resource.public_send(api_method, *path_args.values, query: "query", body: "body", headers: "headers"))
        .to eq "RESPONSE"

      expect(client).to have_received(http_method).with(path, query: "query", body: "body", headers: "headers")
    end
  end

  describe "#{described_class}.#{api_method}" do
    let(:resource) { described_class }
    let(:client) { instance_double(PaypalAPI::Client, http_method => "RESPONSE") }

    before { PaypalAPI.client = client }
    after { PaypalAPI.client = nil }

    it "calls client with correct args" do
      expect(resource.public_send(api_method, *path_args.values, query: "query", body: "body", headers: "headers"))
        .to eq "RESPONSE"

      expect(client).to have_received(http_method).with(path, query: "query", body: "body", headers: "headers")
    end
  end
end
