# frozen_string_literal: true

RSpec.describe PaypalAPI::Request do
  subject(:request) { described_class.new(client, http_method, path, query: query, body: body, headers: headers) }

  let(:client) { instance_double(PaypalAPI::Client, config: config, access_token: access_token) }
  let(:path) { "path" }
  let(:http_method) { Net::HTTP::Get }
  let(:query) { nil }
  let(:body) { nil }
  let(:headers) { nil }
  let(:config) { instance_double(PaypalAPI::Config, url: "https://api-m.paypal.com/foo") }
  let(:access_token) { instance_double(PaypalAPI::AccessToken, authorization_string: "AUTHORIZATION") }

  it "constructs http_request with default headers" do
    expect(request.client).to equal client
    expect(request.requested_at).to be_nil

    http_request = request.http_request
    expect(http_request).to be_a http_method
    expect(http_request.uri).to eq URI("https://api-m.paypal.com/path")
    expect(http_request["authorization"]).to eq "AUTHORIZATION"
    expect(http_request["content-type"]).to eq "application/json"
  end

  it "allows to set requested_at attribute" do
    time = Time.now
    expect(request.requested_at).to be_nil
    request.requested_at = time
    expect(request.requested_at).to equal time
  end

  context "with query parameters" do
    let(:query) { {one: 1, two: 2} }

    it "adds query parameters" do
      http_request = request.http_request
      expect(http_request.uri).to eq URI("https://api-m.paypal.com/path?one=1&two=2")
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
      expect(described_class.new(client, Net::HTTP::Post, path).http_request["paypal-request-id"].length).to eq 36
      expect(described_class.new(client, Net::HTTP::Put, path).http_request["paypal-request-id"].length).to eq 36
      expect(described_class.new(client, Net::HTTP::Patch, path).http_request["paypal-request-id"].length).to eq 36
      expect(described_class.new(client, Net::HTTP::Delete, path).http_request["paypal-request-id"].length).to eq 36
      expect(described_class.new(client, Net::HTTP::Get, path).http_request["paypal-request-id"]).to be_nil
    end
  end
end
