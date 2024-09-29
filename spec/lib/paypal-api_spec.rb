# frozen_string_literal: true

RSpec.describe PaypalAPI do
  describe "#client" do
    it "raises error if client is not set" do
      expect { described_class.client }.to raise_error RuntimeError, "PaypalAPI.client must be set"
    end

    it "returns previously set client" do
      described_class.client = "CLIENT"
      expect(described_class.client).to eq "CLIENT"
    end
  end

  describe "#live?, #sandbox?, #api_url, #web_url" do
    let(:client) do
      instance_double(
        PaypalAPI::Client,
        live?: "LIVE", sandbox?: "SANDBOX",
        api_url: "API_URL", web_url: "WEB_URL"
      )
    end

    before { allow(described_class).to receive(:client).and_return(client) }

    it "delegates to client" do
      expect(described_class.live?).to eq "LIVE"
      expect(described_class.sandbox?).to eq "SANDBOX"
      expect(described_class.api_url).to eq "API_URL"
      expect(described_class.web_url).to eq "WEB_URL"
    end
  end

  describe "#verify_webhook" do
    let(:client) { instance_double(PaypalAPI::Client, verify_webhook: "RESULT") }
    let(:webhook_id) { "webhook_id" }
    let(:headers) { {} }
    let(:raw_body) { "raw_body" }

    before { allow(described_class).to receive(:client).and_return(client) }

    it "calls client" do
      expect(described_class.verify_webhook(webhook_id: webhook_id, headers: headers, raw_body: raw_body)).to eq "RESULT"
      expect(client).to have_received(:verify_webhook).with(webhook_id: webhook_id, headers: headers, raw_body: raw_body)
    end
  end

  [:get, :post, :put, :patch, :delete].each do |http_method|
    describe "##{http_method}" do
      let(:path) { "path" }
      let(:params) { {query: {foo: 1}, body: {bar: 2}, headers: {bazz: 3}} }

      it "delegates ##{http_method} method to client" do
        client = instance_double(PaypalAPI::Client, http_method => "RESPONSE")
        described_class.client = client

        expect(described_class.public_send(http_method, path, **params)).to eq "RESPONSE"
        expect(client).to have_received(http_method).with(path, **params)
      end
    end
  end

  {
    authentication: PaypalAPI::Authentication,
    authorized_payments: PaypalAPI::AuthorizedPayments,
    captured_payments: PaypalAPI::CapturedPayments,
    catalog_products: PaypalAPI::CatalogProducts,
    disputes: PaypalAPI::Disputes,
    invoice_templates: PaypalAPI::InvoiceTemplates,
    invoices: PaypalAPI::Invoices,
    orders: PaypalAPI::Orders,
    partner_referrals: PaypalAPI::PartnerReferrals,
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
    user_info: PaypalAPI::UserInfo,
    users: PaypalAPI::Users,
    webhooks: PaypalAPI::Webhooks,
    webhook_events: PaypalAPI::WebhookEvents,
    webhook_lookups: PaypalAPI::WebhookLookups
  }.each do |resource_method, resource_class|
    describe "##{resource_method}" do
      it "delegates ##{resource_method} method to client" do
        client = instance_double(PaypalAPI::Client, resource_method => "RESOURCE_INSTANCE")
        described_class.client = client

        expect(described_class.public_send(resource_method)).to eq "RESOURCE_INSTANCE"
        expect(client).to have_received(resource_method).with(no_args)
      end
    end
  end
end
