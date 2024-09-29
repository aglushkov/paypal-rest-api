# frozen_string_literal: true

RSpec.describe PaypalAPI::Request do
  subject(:request) { described_class.new(client, http_method, path, query: query, body: body, headers: headers) }

  let(:client) { instance_double(PaypalAPI::Client, env: env, config: config, access_token: access_token) }
  let(:path) { "path" }
  let(:http_method) { Net::HTTP::Get }
  let(:query) { nil }
  let(:body) { nil }
  let(:headers) { nil }
  let(:env) { instance_double(PaypalAPI::Environment, api_url: "https://api-m.paypal.com/foo") }
  let(:config) { instance_double(PaypalAPI::Config) }
  let(:access_token) { instance_double(PaypalAPI::AccessToken, authorization_string: "AUTHORIZATION") }

  it "constructs http_request with default headers" do
    expect(request.client).to equal client

    http_request = request.http_request
    expect(http_request).to be_a http_method
    expect(http_request.uri).to eq URI("https://api-m.paypal.com/path")
    expect(http_request["authorization"]).to eq "AUTHORIZATION"
    expect(http_request["content-type"]).to eq "application/json"
  end

  context "with query parameters" do
    let(:query) { {one: 1, two: 2} }

    it "adds query parameters" do
      http_request = request.http_request
      expect(http_request.uri).to eq URI("https://api-m.paypal.com/path?one=1&two=2")
    end
  end

  context "with query parameters conflicting with path query parameters" do
    let(:path) { "path?one=old1&three=3" }
    let(:query) { {one: 1, two: 2} }

    it "merges query parameters" do
      http_request = request.http_request
      expect(http_request.uri).to eq URI("https://api-m.paypal.com/path?one=1&three=3&two=2")
    end
  end

  context "with custom headers" do
    let(:headers) do
      {:one => 1, "Authorization" => "AUTH", "Content-Type" => "multipart/form-data", "PayPal-Request-Id" => 123}
    end

    it "adds provided headers" do
      http_request = request.http_request
      expect(http_request["authorization"]).to eq "AUTH"
      expect(http_request["content-type"]).to eq "multipart/form-data"
      expect(http_request["paypal-request-id"]).to eq "123"
    end
  end

  context "with custom body" do
    let(:body) { {one: 1} }

    it "adds json body" do
      http_request = request.http_request
      expect(http_request.body).to eq '{"one":1}'
      expect(http_request["content-type"]).to eq "application/json"
    end
  end

  context "with custom body and non-json content-type" do
    let(:body) { {one: 1} }
    let(:headers) { {"content-type" => "xxx"} }

    it "adds multipart form body" do
      http_request = request.http_request
      expect(http_request.body).to eq "one=1"
    end
  end

  context "with POST, PUT, PATCH, DELETE requests" do
    it "adds unique paypal-request-id header" do
      expect(described_class.new(client, Net::HTTP::Post, path).headers["paypal-request-id"]).to be_a(String)
      expect(described_class.new(client, Net::HTTP::Put, path).headers["paypal-request-id"]).to be_a(String)
      expect(described_class.new(client, Net::HTTP::Patch, path).headers["paypal-request-id"]).to be_a(String)
      expect(described_class.new(client, Net::HTTP::Delete, path).headers["paypal-request-id"]).to be_a(String)
    end
  end

  context "with GET requests" do
    it "does not add paypal-request-id header" do
      expect(described_class.new(client, Net::HTTP::Get, path).headers).not_to have_key("paypal-request-id")
    end
  end

  describe "#method" do
    it "return HTTP method name" do
      expect(described_class.new(client, Net::HTTP::Post, path).method).to eq "POST"
      expect(described_class.new(client, Net::HTTP::Put, path).method).to eq "PUT"
      expect(described_class.new(client, Net::HTTP::Patch, path).method).to eq "PATCH"
      expect(described_class.new(client, Net::HTTP::Delete, path).method).to eq "DELETE"
      expect(described_class.new(client, Net::HTTP::Get, path).method).to eq "GET"
    end
  end

  describe "#path" do
    it "return path" do
      expect(described_class.new(client, Net::HTTP::Post, "/foo/bar").path).to eq "/foo/bar"
    end
  end

  describe "#body" do
    it "returns body string" do
      expect(described_class.new(client, Net::HTTP::Post, path, body: {a: 1}).body).to eq({a: 1}.to_json)
    end
  end
end
