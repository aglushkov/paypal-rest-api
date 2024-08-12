# frozen_string_literal: true

RSpec.describe PaypalAPI::NetworkErrorBuilder do
  let(:original_error) { StandardError.new(message: "message") }
  let(:request) { instance_double(PaypalAPI::Request, http_request: http_request) }
  let(:http_request) { instance_double(Net::HTTPRequest, :[] => nil) }

  it "converts any error" do
    error = described_class.call(error: original_error, request: request)

    expect(error).to be_a PaypalAPI::Errors::NetworkError
    expect(error.message).to eq original_error.message
    expect(error.request).to eq request
  end
end
