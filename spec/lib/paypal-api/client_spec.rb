# frozen_string_literal: true

RSpec.describe PaypalAPI::Client do
  subject(:client) { described_class.new(**opts) }

  let(:opts) { {client_id: "CLIENT_ID", client_secret: "CLIENT_SECRET"} }

  describe "#new" do
    let(:config) { instance_double(PaypalAPI::Config) }
    let(:env) { instance_double(PaypalAPI::Environment) }

    let(:opts) do
      {
        client_id: "CLIENT_ID",
        client_secret: "CLIENT_SECRET",
        live: "LIVE",
        retries: "RETRIES",
        http_opts: "HTTP_OPTS",
        cache: "CACHE"
      }
    end

    before do
      allow(PaypalAPI::Config).to receive(:new)
        .with(retries: "RETRIES", http_opts: "HTTP_OPTS", cache: "CACHE")
        .and_return(config)

      allow(PaypalAPI::Environment).to receive(:new)
        .with(client_id: "CLIENT_ID", client_secret: "CLIENT_SECRET", live: "LIVE")
        .and_return(env)
    end

    it "constructs env, config and callbacks with provided params" do
      expect(client).to be_a described_class
      expect(client.config).to equal config
      expect(client.callbacks).to eq(
        before: [],
        after_success: [],
        after_fail: [],
        after_network_error: []
      )
    end
  end

  describe "#live?, #sandbox?, #api_url, #web_url" do
    let(:client) { described_class.new(**opts) }
    let(:env) do
      instance_double(
        PaypalAPI::Environment,
        live?: "LIVE", sandbox?: "SANDBOX",
        api_url: "API_URL", web_url: "WEB_URL"
      )
    end

    before { allow(client).to receive(:env).and_return(env) }

    it "delegates to env" do
      expect(client.live?).to eq "LIVE"
      expect(client.sandbox?).to eq "SANDBOX"
      expect(client.api_url).to eq "API_URL"
      expect(client.web_url).to eq "WEB_URL"
    end
  end

  describe "resources" do
    resources = {
      authentication: PaypalAPI::Authentication,
      authorized_payments: PaypalAPI::AuthorizedPayments,
      captured_payments: PaypalAPI::CapturedPayments,
      catalog_products: PaypalAPI::CatalogProducts,
      disputes: PaypalAPI::Disputes,
      invoice_templates: PaypalAPI::InvoiceTemplates,
      invoices: PaypalAPI::Invoices,
      orders: PaypalAPI::Orders,
      partner_referrals: PaypalAPI::PartnerReferrals,
      payment_experience_web_profiles: PaypalAPI::PaymentExperienceWebProfiles,
      payment_tokens: PaypalAPI::PaymentTokens,
      payout_items: PaypalAPI::PayoutItems,
      payouts: PaypalAPI::Payouts,
      refunds: PaypalAPI::Refunds,
      referenced_payout_items: PaypalAPI::ReferencedPayoutItems,
      referenced_payouts: PaypalAPI::ReferencedPayouts,
      setup_tokens: PaypalAPI::SetupTokens,
      shipment_tracking: PaypalAPI::ShipmentTracking,
      subscriptions: PaypalAPI::Subscriptions,
      subscription_plans: PaypalAPI::SubscriptionPlans,
      transaction_search: PaypalAPI::TransactionSearch,
      user_info: PaypalAPI::UserInfo,
      users: PaypalAPI::Users,
      webhooks: PaypalAPI::Webhooks,
      webhook_events: PaypalAPI::WebhookEvents,
      webhook_lookups: PaypalAPI::WebhookLookups
    }

    resources.each do |method_name, resource_class|
      describe "##{method_name}" do
        before { allow(resource_class).to receive(:new).with(client).and_return("INITIALIZED_RESOURCE_CLASS") }

        it "initializes #{resource_class} instance" do
          expect(client.public_send(method_name)).to eq "INITIALIZED_RESOURCE_CLASS"
        end
      end
    end
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
      let(:authentication) { instance_double(PaypalAPI::Authentication, generate_access_token: response) }
      let(:response) { instance_double(PaypalAPI::Response) }
      let(:new_access_token) { instance_double(PaypalAPI::AccessToken) }

      before do
        allow(PaypalAPI::Authentication).to receive(:new).with(client).and_return(authentication)
        allow(PaypalAPI::AccessToken).to receive(:new).and_return(new_access_token)
        allow(response).to receive(:fetch).with(:access_token).and_return("ACCESS_TOKEN")
        allow(response).to receive(:fetch).with(:token_type).and_return("TOKEN_TYPE")
        allow(response).to receive(:fetch).with(:expires_in).and_return("EXPIRES_IN")
        allow(Time).to receive(:now).and_return("REQUESTED_AT")
      end

      it "generates new access token" do
        expect(client.access_token).to equal new_access_token
        expect(Time).to have_received(:now)
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
      let(:authentication) { instance_double(PaypalAPI::Authentication, generate_access_token: response) }
      let(:response) { instance_double(PaypalAPI::Response) }
      let(:new_access_token) { instance_double(PaypalAPI::AccessToken) }

      before do
        client.instance_variable_set(:@access_token, old_access_token)
        allow(PaypalAPI::Authentication).to receive(:new).with(client).and_return(authentication)
        allow(PaypalAPI::AccessToken).to receive(:new).and_return(new_access_token)
        allow(response).to receive(:fetch).with(:access_token).and_return("ACCESS_TOKEN")
        allow(response).to receive(:fetch).with(:token_type).and_return("TOKEN_TYPE")
        allow(response).to receive(:fetch).with(:expires_in).and_return("EXPIRES_IN")
        allow(Time).to receive(:now).and_return("REQUESTED_AT")
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
    let(:authentication) { instance_double(PaypalAPI::Authentication, generate_access_token: response) }
    let(:response) { instance_double(PaypalAPI::Response) }
    let(:new_access_token) { instance_double(PaypalAPI::AccessToken) }

    before do
      client.instance_variable_set(:@access_token, "OLD_TOKEN")
      allow(PaypalAPI::Authentication).to receive(:new).with(client).and_return(authentication)
      allow(PaypalAPI::AccessToken).to receive(:new).and_return(new_access_token)
      allow(response).to receive(:fetch).with(:access_token).and_return("ACCESS_TOKEN")
      allow(response).to receive(:fetch).with(:token_type).and_return("TOKEN_TYPE")
      allow(response).to receive(:fetch).with(:expires_in).and_return("EXPIRES_IN")
      allow(Time).to receive(:now).and_return("REQUESTED_AT")
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

  describe "#add_callback" do
    it "stores added callbacks" do
      callback1 = proc {}
      callback2 = proc {}
      callback3 = proc {}

      client.add_callback(:before, &callback1)
      client.add_callback(:before, &callback2)

      client.add_callback(:after_success, &callback2)
      client.add_callback(:after_success, &callback3)

      client.add_callback(:after_fail, &callback2)
      client.add_callback(:after_fail, &callback3)

      client.add_callback(:after_network_error, &callback2)
      client.add_callback(:after_network_error, &callback3)

      expect(client.callbacks[:before]).to eq [callback1, callback2]
      expect(client.callbacks[:after_success]).to eq [callback2, callback3]
      expect(client.callbacks[:after_fail]).to eq [callback2, callback3]
      expect(client.callbacks[:after_network_error]).to eq [callback2, callback3]
    end
  end

  describe "#verify_webhook" do
    let(:verifier) { instance_double(PaypalAPI::WebhookVerifier, call: "RESULT") }
    let(:webhook_id) { "webhook_id" }
    let(:headers) { {} }
    let(:raw_body) { "raw_body" }

    before { allow(PaypalAPI::WebhookVerifier).to receive(:new).with(client).and_return(verifier) }

    it "calls webhook verifier" do
      expect(client.verify_webhook(webhook_id: webhook_id, headers: headers, raw_body: raw_body)).to eq "RESULT"
      expect(verifier).to have_received(:call).with(webhook_id: webhook_id, headers: headers, raw_body: raw_body)
    end
  end

  describe "http methods" do
    let(:request_executor) { instance_double(PaypalAPI::RequestExecutor, call: "RESPONSE") }

    before do
      allow(PaypalAPI::Request).to receive(:new).and_return("REQUEST")
      allow(PaypalAPI::RequestExecutor).to receive(:new).and_return(request_executor)
    end

    describe "#post" do
      let(:http_method) { Net::HTTP::Post }

      it "constructs and executes request" do
        expect(client.post("path", body: "body", headers: "headers")).to eq "RESPONSE"

        expect(PaypalAPI::Request).to have_received(:new)
          .with(client, http_method, "path", query: nil, body: "body", headers: "headers")

        expect(PaypalAPI::RequestExecutor).to have_received(:new).with(client, "REQUEST")
        expect(request_executor).to have_received(:call)
      end
    end

    describe "#get" do
      let(:http_method) { Net::HTTP::Get }

      it "constructs and executes request" do
        expect(client.get("path", query: "query", headers: "headers")).to eq "RESPONSE"

        expect(PaypalAPI::Request).to have_received(:new)
          .with(client, http_method, "path", query: "query", body: nil, headers: "headers")

        expect(PaypalAPI::RequestExecutor).to have_received(:new).with(client, "REQUEST")
        expect(request_executor).to have_received(:call)
      end
    end

    describe "#delete" do
      let(:http_method) { Net::HTTP::Delete }

      it "constructs an executes request" do
        expect(client.delete("path", headers: "headers")).to eq "RESPONSE"

        expect(PaypalAPI::Request).to have_received(:new)
          .with(client, http_method, "path", query: nil, body: nil, headers: "headers")

        expect(PaypalAPI::RequestExecutor).to have_received(:new).with(client, "REQUEST")
        expect(request_executor).to have_received(:call)
      end
    end

    describe "#put" do
      let(:http_method) { Net::HTTP::Put }

      it "constructs an executes request" do
        expect(client.put("path", body: "body", headers: "headers")).to eq "RESPONSE"

        expect(PaypalAPI::Request).to have_received(:new)
          .with(client, http_method, "path", query: nil, body: "body", headers: "headers")

        expect(PaypalAPI::RequestExecutor).to have_received(:new).with(client, "REQUEST")
        expect(request_executor).to have_received(:call)
      end
    end

    describe "#patch" do
      let(:http_method) { Net::HTTP::Patch }

      it "constructs an executes request" do
        expect(client.patch("path", body: "body", headers: "headers")).to eq "RESPONSE"

        expect(PaypalAPI::Request).to have_received(:new)
          .with(client, http_method, "path", query: nil, body: "body", headers: "headers")

        expect(PaypalAPI::RequestExecutor).to have_received(:new).with(client, "REQUEST")
        expect(request_executor).to have_received(:call)
      end
    end
  end
end
