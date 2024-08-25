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
    payout_items: PaypalAPI::PayoutItems,
    payouts: PaypalAPI::Payouts,
    refunds: PaypalAPI::Refunds,
    referenced_payout_items: PaypalAPI::ReferencedPayoutItems,
    referenced_payouts: PaypalAPI::ReferencedPayouts,
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
