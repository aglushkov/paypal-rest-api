# frozen_string_literal: true

RSpec.describe PaypalAPI::Response do
  subject(:response) { described_class.new(http_response, requested_at: requested_at) }

  let(:http_response) do
    instance_double(
      Net::HTTPResponse,
      code: "200",
      body: body,
      each_header: each_header
    )
  end

  let(:body) { '{"foo":"bar"}' }
  let(:each_header) { {a: 1, b: 2}.each }
  let(:requested_at) { Time.now }

  before { allow(http_response).to receive(:[]).with("content-type").and_return("application/json") }

  context "with json response" do
    it "returns correct data" do
      expect(response.requested_at).to equal requested_at
      expect(response.http_headers).to eq(a: 1, b: 2)
      expect(response.http_response).to equal http_response
      expect(response.http_status).to equal 200
      expect(response.http_body).to equal body
      expect(response.body).to eq(foo: "bar")
      expect(response[:foo]).to eq "bar"
      expect(response.fetch(:foo)).to eq "bar"
    end

    context "with non-parsable body" do
      let(:body) { 123 }

      it "returns original http body" do
        expect(response.body).to eq(123)
      end
    end
  end

  context "with non-json response" do
    before { allow(http_response).to receive(:[]).with("content-type").and_return("text/html") }

    it "returns correct data" do
      expect(response.requested_at).to equal requested_at
      expect(response.http_headers).to eq(a: 1, b: 2)
      expect(response.http_response).to equal http_response
      expect(response.http_status).to equal 200
      expect(response.http_body).to equal body
      expect(response.body).to eq(body)
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
end
