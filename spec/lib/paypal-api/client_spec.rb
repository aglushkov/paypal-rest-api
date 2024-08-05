# frozen_string_literal: true

RSpec.describe PaypalAPI::Client do
  subject(:client) { described_class.new(**opts) }

  let(:config) { instance_double(PaypalAPI::Config) }
  let(:opts) { {client_id: "CLIENT_ID", client_secret: "CLIENT_SECRET"} }

  before do
    allow(PaypalAPI::Config).to receive(:new).with(live: nil, http_opts: nil, retries: nil, **opts).and_return(config)
  end

  it "constructs config with provided params" do
    expect(client).to be_a described_class
    expect(client.config).to equal config
  end

  describe "#access_token" do
    context "when already set" do
      before { client.instance_variable_set(:@access_token, access_token) }

      let(:access_token) { instance_double(PaypalAPI::AccessToken, expired?: false) }

      it "returns saved access token" do
        expect(client.access_token).to equal access_token
        expect(access_token).to have_received(:expired?)
      end
    end

    context "when not set" do
      let(:authorization) { instance_double(PaypalAPI::Authentication, generate_access_token: response) }
      let(:response) { instance_double(PaypalAPI::Response) }
      let(:new_access_token) { instance_double(PaypalAPI::AccessToken) }

      before do
        allow(PaypalAPI::Authentication).to receive(:new).with(client).and_return(authorization)
        allow(PaypalAPI::AccessToken).to receive(:new).and_return(new_access_token)
        allow(response).to receive(:fetch).with(:access_token).and_return("ACCESS_TOKEN")
        allow(response).to receive(:fetch).with(:token_type).and_return("TOKEN_TYPE")
        allow(response).to receive(:fetch).with(:expires_in).and_return("EXPIRES_IN")
        allow(response).to receive(:requested_at).with(no_args).and_return("REQUESTED_AT")
      end

      it "generates new access token" do
        expect(client.access_token).to equal new_access_token
        expect(PaypalAPI::AccessToken).to have_received(:new).with(
          access_token: "ACCESS_TOKEN",
          token_type: "TOKEN_TYPE",
          expires_in: "EXPIRES_IN",
          requested_at: "REQUESTED_AT"
        )
      end
    end

    context "when expired" do
      let(:old_access_token) { instance_double(PaypalAPI::AccessToken, expired?: true) }
      let(:authorization) { instance_double(PaypalAPI::Authentication, generate_access_token: response) }
      let(:response) { instance_double(PaypalAPI::Response) }
      let(:new_access_token) { instance_double(PaypalAPI::AccessToken) }

      before do
        client.instance_variable_set(:@access_token, old_access_token)
        allow(PaypalAPI::Authentication).to receive(:new).with(client).and_return(authorization)
        allow(PaypalAPI::AccessToken).to receive(:new).and_return(new_access_token)
        allow(response).to receive(:fetch).with(:access_token).and_return("ACCESS_TOKEN")
        allow(response).to receive(:fetch).with(:token_type).and_return("TOKEN_TYPE")
        allow(response).to receive(:fetch).with(:expires_in).and_return("EXPIRES_IN")
        allow(response).to receive(:requested_at).with(no_args).and_return("REQUESTED_AT")
      end

      it "generates new access token" do
        expect(client.access_token).to equal new_access_token
        expect(old_access_token).to have_received(:expired?).with(no_args)
        expect(PaypalAPI::AccessToken).to have_received(:new).with(
          access_token: "ACCESS_TOKEN",
          token_type: "TOKEN_TYPE",
          expires_in: "EXPIRES_IN",
          requested_at: "REQUESTED_AT"
        )
      end
    end
  end

  describe "#refresh_access_token" do
    let(:authorization) { instance_double(PaypalAPI::Authentication, generate_access_token: response) }
    let(:response) { instance_double(PaypalAPI::Response) }
    let(:new_access_token) { instance_double(PaypalAPI::AccessToken) }

    before do
      client.instance_variable_set(:@access_token, "OLD_TOKEN")
      allow(PaypalAPI::Authentication).to receive(:new).with(client).and_return(authorization)
      allow(PaypalAPI::AccessToken).to receive(:new).and_return(new_access_token)
      allow(response).to receive(:fetch).with(:access_token).and_return("ACCESS_TOKEN")
      allow(response).to receive(:fetch).with(:token_type).and_return("TOKEN_TYPE")
      allow(response).to receive(:fetch).with(:expires_in).and_return("EXPIRES_IN")
      allow(response).to receive(:requested_at).with(no_args).and_return("REQUESTED_AT")
    end

    it "generates new access token" do
      expect(client.refresh_access_token).to equal new_access_token
      expect(client.instance_variable_get(:@access_token)).to equal new_access_token
      expect(PaypalAPI::AccessToken).to have_received(:new).with(
        access_token: "ACCESS_TOKEN",
        token_type: "TOKEN_TYPE",
        expires_in: "EXPIRES_IN",
        requested_at: "REQUESTED_AT"
      )
    end
  end

  describe "http methods" do
    before do
      allow(PaypalAPI::Request).to receive(:new).and_return("REQUEST")
      allow(PaypalAPI::RequestExecutor).to receive(:call).and_return("RESPONSE")
    end

    describe "#post" do
      let(:http_method) { Net::HTTP::Post }

      it "constructs an executes request" do
        expect(client.post("path", body: "body", headers: "headers")).to eq "RESPONSE"

        expect(PaypalAPI::Request).to have_received(:new)
          .with(client, http_method, "path", query: nil, body: "body", headers: "headers")

        expect(PaypalAPI::RequestExecutor).to have_received(:call).with("REQUEST")
      end
    end

    describe "#get" do
      let(:http_method) { Net::HTTP::Get }

      it "constructs an executes request" do
        expect(client.get("path", query: "query", headers: "headers")).to eq "RESPONSE"

        expect(PaypalAPI::Request).to have_received(:new)
          .with(client, http_method, "path", query: "query", body: nil, headers: "headers")

        expect(PaypalAPI::RequestExecutor).to have_received(:call).with("REQUEST")
      end
    end

    describe "#delete" do
      let(:http_method) { Net::HTTP::Delete }

      it "constructs an executes request" do
        expect(client.delete("path", headers: "headers")).to eq "RESPONSE"

        expect(PaypalAPI::Request).to have_received(:new)
          .with(client, http_method, "path", query: nil, body: nil, headers: "headers")

        expect(PaypalAPI::RequestExecutor).to have_received(:call).with("REQUEST")
      end
    end

    describe "#put" do
      let(:http_method) { Net::HTTP::Put }

      it "constructs an executes request" do
        expect(client.put("path", body: "body", headers: "headers")).to eq "RESPONSE"

        expect(PaypalAPI::Request).to have_received(:new)
          .with(client, http_method, "path", query: nil, body: "body", headers: "headers")

        expect(PaypalAPI::RequestExecutor).to have_received(:call).with("REQUEST")
      end
    end

    describe "#patch" do
      let(:http_method) { Net::HTTP::Patch }

      it "constructs an executes request" do
        expect(client.patch("path", body: "body", headers: "headers")).to eq "RESPONSE"

        expect(PaypalAPI::Request).to have_received(:new)
          .with(client, http_method, "path", query: nil, body: "body", headers: "headers")

        expect(PaypalAPI::RequestExecutor).to have_received(:call).with("REQUEST")
      end
    end
  end

  describe "resources" do
    resources = {
      authorization: PaypalAPI::Authentication,
      orders: PaypalAPI::Orders,
      payments: PaypalAPI::Payments,
      webhooks: PaypalAPI::Webhooks
    }

    resources.each do |method_name, resource_class|
      describe "##{method_name}" do
        before { allow(resource_class).to receive(:new).with(client).and_return("INITIALIZED_RESOURCE_CLASS") }

        it "initializes #{resource_class} instance" do
          expect(client.public_send(method_name)).to equal "INITIALIZED_RESOURCE_CLASS"
        end
      end
    end
  end
end
