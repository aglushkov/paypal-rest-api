# frozen_string_literal: true

RSpec.describe PaypalAPI::NetworkErrorBuilder do
  let(:original_error) { StandardError.new(message: "message") }

  it "converts any error" do
    error = described_class.call(error: original_error, request: "request")

    expect(error).to be_a PaypalAPI::NetworkError
    expect(error.message).to eq original_error.message
    expect(error.request).to eq "request"
  end
end
