# frozen_string_literal: true

RSpec.describe PaypalAPI::PartnerReferrals do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v2/customer/partner-referrals"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v2/customer/partner-referrals/%<partner_referral_id>s",
    path_args: {partner_referral_id: "123"}
end
