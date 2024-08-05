# frozen_string_literal: true

require "timecop"

RSpec.describe PaypalAPI::AccessToken do
  subject(:token) do
    described_class.new(
      requested_at: requested_at,
      expires_in: expires_in,
      access_token: access_token,
      token_type: token_type
    )
  end

  let(:now) { Time.now }
  let(:expires_in) { 10 }
  let(:access_token) { "ACCESS_TOKEN" }
  let(:token_type) { "BEARER" }

  context "with valid access_token" do
    let(:requested_at) { now - expires_in + 0.000001 }

    it "returns access token" do
      Timecop.freeze do
        expect(token).to be_frozen
        expect(token.expired?).to be false
        expect(token.requested_at).to be requested_at
        expect(token.authorization_string).to eq "#{token_type} #{access_token}"
        expect(token.inspect).not_to include access_token
        expect(token.to_s).not_to include access_token
      end
    end
  end

  context "with expired access_token" do
    let(:requested_at) { now - expires_in }

    it "returns access token" do
      Timecop.freeze do
        expect(token.expired?).to be true
      end
    end
  end
end
