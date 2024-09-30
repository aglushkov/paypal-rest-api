# frozen_string_literal: true

RSpec.describe PaypalAPI::Response do
  subject(:response) { described_class.new(http_response, request: request) }

  let(:http_response) do
    instance_double(
      Net::HTTPResponse,
      code: "200",
      body: response_body,
      each_header: each_header
    )
  end

  let(:response_body) { '{"foo":"bar"}' }
  let(:each_header) { {a: 1, b: 2}.each }
  let(:request) { instance_double(PaypalAPI::Request, client: client) }
  let(:client) { instance_double(PaypalAPI::Client, get: :get_response, post: :post_response) }

  before { allow(http_response).to receive(:[]).with("content-type").and_return("application/json") }

  context "with json response" do
    it "returns correct data" do
      expect(response.request).to equal request
      expect(response.http_headers).to eq(a: 1, b: 2)
      expect(response.http_response).to equal http_response
      expect(response.http_status).to equal 200
      expect(response.http_body).to equal response_body
      expect(response.body).to eq(foo: "bar")
      expect(response[:foo]).to eq "bar"
      expect(response.fetch(:foo)).to eq "bar"
    end

    context "with non-parsable body" do
      let(:response_body) { 123 }

      it "returns original http body" do
        expect(response.body).to eq(123)
      end
    end
  end

  context "with non-json response" do
    before { allow(http_response).to receive(:[]).with("content-type").and_return("text/html") }

    it "returns correct data" do
      expect(response.request).to equal request
      expect(response.http_headers).to eq(a: 1, b: 2)
      expect(response.http_response).to equal http_response
      expect(response.http_status).to equal 200
      expect(response.http_body).to equal response_body
      expect(response.body).to eq(response_body)
      expect(response[:foo]).to be_nil
      expect { response.fetch(:foo) }.to raise_error KeyError
    end
  end

  describe "#inspect" do
    it "shows only status" do
      response.body # load body
      expect(response.inspect).to eq "#<PaypalAPI::Response (200)>"
    end
  end

  describe "#follow_up_link" do
    let(:response_body) { JSON.dump(links: links) }
    let(:query) { "QUERY" }
    let(:body) { "BODY" }
    let(:headers) { "HEADERS" }

    context "with GET link" do
      let(:links) { [{rel: "get_rel", href: "https://api-m.paypal.com/get", method: "GET"}] }

      it "follows up GET link" do
        expect(response.follow_up_link("get_rel")).to eq :get_response

        expect(client)
          .to have_received(:get)
          .with("https://api-m.paypal.com/get", query: nil, body: nil, headers: nil)
      end

      it "follows up GET link with params" do
        expect(response.follow_up_link("get_rel", query: query, body: body, headers: headers)).to eq :get_response

        expect(client)
          .to have_received(:get)
          .with("https://api-m.paypal.com/get", query: query, body: body, headers: headers)
      end
    end

    context "with POST link" do
      let(:links) { [{rel: "post_rel", href: "https://api-m.paypal.com/post", method: "POST"}] }

      it "follows up POST link" do
        expect(response.follow_up_link("post_rel")).to eq :post_response

        expect(client)
          .to have_received(:post)
          .with("https://api-m.paypal.com/post", query: nil, body: nil, headers: nil)
      end

      it "follows up POST link with params" do
        expect(response.follow_up_link("post_rel", query: query, body: body, headers: headers)).to eq :post_response

        expect(client)
          .to have_received(:post)
          .with("https://api-m.paypal.com/post", query: query, body: body, headers: headers)
      end
    end

    context "with link without method" do
      let(:links) { [{rel: "get_rel", href: "https://api-m.paypal.com/get"}] }

      it "uses GET method" do
        expect(response.follow_up_link("get_rel")).to eq :get_response

        expect(client)
          .to have_received(:get)
          .with("https://api-m.paypal.com/get", query: nil, body: nil, headers: nil)
      end
    end

    context "when response is not a Hash" do
      let(:response_body) { "foobar" }

      it "returns nil" do
        expect(response.follow_up_link("get_rel")).to be_nil
      end
    end

    context "when response has no links" do
      let(:response_body) { "{}" }

      it "returns nil" do
        expect(response.follow_up_link("get_rel")).to be_nil
      end
    end

    context "when response has no link with provided rel" do
      let(:links) { [] }

      it "returns nil" do
        expect(response.follow_up_link("get_rel")).to be_nil
      end
    end
  end
end
