# frozen_string_literal: true

RSpec.describe PaypalAPI::Authentication do
  describe "#generate_access_token" do
    let(:path) { "/v1/oauth2/token" }
    let(:resource) { described_class.new(client) }
    let(:env) { instance_double(PaypalAPI::Environment, client_id: "123", client_secret: "456") }
    let(:client) { instance_double(PaypalAPI::Client, post: "RESPONSE", env: env) }

    it "calls client with correct args" do
      expect(resource.generate_access_token).to eq "RESPONSE"
      expect(client).to have_received(:post)
        .with(
          path,
          query: nil,
          body: {grant_type: "client_credentials"},
          headers: {
            "content-type" => "application/x-www-form-urlencoded",
            "authorization" => "Basic #{["123:456"].pack("m0")}"
          }
        )
    end

    it "uses provided body and merges headers" do
      expect(resource.generate_access_token(body: "body", headers: {foo: :bar})).to eq "RESPONSE"
      expect(client).to have_received(:post)
        .with(
          path,
          query: nil,
          body: "body",
          headers: {
            "foo" => :bar,
            "content-type" => "application/x-www-form-urlencoded",
            "authorization" => "Basic #{["123:456"].pack("m0")}"
          }
        )
    end
  end

  describe ".generate_access_token" do
    let(:path) { "/v1/oauth2/token" }
    let(:resource) { described_class }
    let(:env) { instance_double(PaypalAPI::Environment, client_id: "123", client_secret: "456") }
    let(:client) { instance_double(PaypalAPI::Client, post: "RESPONSE", env: env) }

    before { PaypalAPI.client = client }
    after { PaypalAPI.client = nil }

    it "calls client with correct args" do
      expect(resource.generate_access_token).to eq "RESPONSE"
      expect(client).to have_received(:post)
        .with(
          path,
          query: nil,
          body: {grant_type: "client_credentials"},
          headers: {
            "content-type" => "application/x-www-form-urlencoded",
            "authorization" => "Basic #{["123:456"].pack("m0")}"
          }
        )
    end

    it "uses provided body and merges headers" do
      expect(resource.generate_access_token(body: "body", headers: {foo: :bar})).to eq "RESPONSE"
      expect(client).to have_received(:post)
        .with(
          path,
          query: nil,
          body: "body",
          headers: {
            "foo" => :bar,
            "content-type" => "application/x-www-form-urlencoded",
            "authorization" => "Basic #{["123:456"].pack("m0")}"
          }
        )
    end
  end
end
