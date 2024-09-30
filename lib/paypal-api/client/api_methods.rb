# frozen_string_literal: true

module PaypalAPI
  class Client
    #
    # Methods to access API collections
    #
    module APIMethods
      # @return [AuthorizedPayments] AuthorizedPayments APIs collection
      def authorized_payments
        AuthorizedPayments.new(self)
      end

      # @return [CapturedPayments] CapturedPayments APIs collection
      def captured_payments
        CapturedPayments.new(self)
      end

      # @return [Authentication] Authentication APIs collection
      def authentication
        Authentication.new(self)
      end

      # @return [CatalogProducts] Catalog Products APIs collection
      def catalog_products
        CatalogProducts.new(self)
      end

      # @return [Disputes] Disputes APIs collection
      def disputes
        Disputes.new(self)
      end

      # @return [InvoiceTemplates] InvoiceTemplates APIs collection
      def invoice_templates
        InvoiceTemplates.new(self)
      end

      # @return [Invoices] Invoices APIs collection
      def invoices
        Invoices.new(self)
      end

      # @return [Orders] Orders APIs collection
      def orders
        Orders.new(self)
      end

      # @return [PartnerReferrals] PartnerReferrals APIs collection
      def partner_referrals
        PartnerReferrals.new(self)
      end

      # @return [PaymentExperienceWebProfiles] PaymentExperienceWebProfiles APIs collection
      def payment_experience_web_profiles
        PaymentExperienceWebProfiles.new(self)
      end

      # @return [PaymentTokens] PaymentTokens APIs collection
      def payment_tokens
        PaymentTokens.new(self)
      end

      # @return [PayoutItems] PayoutItems APIs collection
      def payout_items
        PayoutItems.new(self)
      end

      # @return [Payouts] Payouts APIs collection
      def payouts
        Payouts.new(self)
      end

      # @return [Refunds] Refunds APIs collection
      def refunds
        Refunds.new(self)
      end

      # @return [ReferencedPayoutItems] ReferencedPayoutItems APIs collection
      def referenced_payout_items
        ReferencedPayoutItems.new(self)
      end

      # @return [ReferencedPayouts] ReferencedPayouts APIs collection
      def referenced_payouts
        ReferencedPayouts.new(self)
      end

      # @return [SetupTokens] SetupTokens APIs collection
      def setup_tokens
        SetupTokens.new(self)
      end

      # @return [ShipmentTracking] Shipment Tracking APIs collection
      def shipment_tracking
        ShipmentTracking.new(self)
      end

      # @return [Subscriptions] Subscriptions APIs collection
      def subscriptions
        Subscriptions.new(self)
      end

      # @return [SubscriptionPlans] Subscription Plans APIs collection
      def subscription_plans
        SubscriptionPlans.new(self)
      end

      # @return [TransactionSearch] TransactionSearch APIs collection
      def transaction_search
        TransactionSearch.new(self)
      end

      # @return [UserInfo] User Info APIs collection
      def user_info
        UserInfo.new(self)
      end

      # @return [Users] Users Management APIs collection
      def users
        Users.new(self)
      end

      # @return [Webhooks] Webhooks APIs collection
      def webhooks
        Webhooks.new(self)
      end

      # @return [WebhookEvents] Webhook Events APIs collection
      def webhook_lookups
        WebhookLookups.new(self)
      end

      # @return [WebhookEvents] Webhook Lookups APIs collection
      def webhook_events
        WebhookEvents.new(self)
      end
    end
  end
end
