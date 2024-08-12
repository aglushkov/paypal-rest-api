# frozen_string_literal: true

RSpec.describe PaypalAPI::Error do
  describe PaypalAPI::Errors::FailedRequest do
    let(:request) { instance_double(PaypalAPI::Request) }
    let(:response) do
      instance_double(
        PaypalAPI::Response,
        body: body,
        http_body: http_body,
        http_response: http_response
      )
    end

    let(:http_body) { 123 }
    let(:http_response) { Net::HTTPForbidden.allocate }

    context "when body is a Hash with full error details" do
      let(:body) do
        {
          name: "NAME",
          message: "MESSAGE",
          debug_id: "DEBUG_ID",
          details: "DETAILS"
        }
      end

      it "sets correct attributes" do
        error = described_class.new("error", response: response, request: request)

        expect(error.message).to eq "error"
        expect(error.request).to equal request
        expect(error.response).to equal response

        expect(error.error_name).to eq "NAME"
        expect(error.error_message).to eq "MESSAGE"
        expect(error.error_debug_id).to eq "DEBUG_ID"
        expect(error.error_details).to eq "DETAILS"
      end
    end

    context "when body is a Hash with only error and error_description fields" do
      let(:body) do
        {
          error: "ERROR",
          error_description: "ERROR_DESCRIPTIOM"
        }
      end

      it "sets correct attributes" do
        error = described_class.new("error", response: response, request: request)

        expect(error.message).to eq "error"
        expect(error.request).to equal request
        expect(error.response).to equal response

        expect(error.error_name).to eq "ERROR"
        expect(error.error_message).to eq "ERROR_DESCRIPTIOM"
        expect(error.error_debug_id).to be_nil
        expect(error.error_details).to be_nil
      end
    end

    context "when body is nil" do
      let(:body) { nil }

      it "sets correct attributes" do
        error = described_class.new("error", response: response, request: request)

        expect(error.message).to eq "error"
        expect(error.request).to equal request
        expect(error.response).to equal response

        expect(error.error_name).to eq http_response.class.name
        expect(error.error_message).to eq http_body.to_s
        expect(error.error_debug_id).to be_nil
        expect(error.error_details).to be_nil
      end
    end
  end

  describe PaypalAPI::Errors::NetworkError do
    it "has message and detailed message" do
      original_error = StandardError.new("message")
      request = instance_double(PaypalAPI::Request)
      error = described_class.new("error", request: request, error: original_error)

      expect(error.message).to eq "error"
      expect(error.request).to equal request
      expect(error.response).to equal nil

      expect(error.error_name).to eq original_error.class.name
      expect(error.error_message).to eq original_error.message
      expect(error.error_debug_id).to be_nil
      expect(error.error_details).to be_nil
    end
  end
end
