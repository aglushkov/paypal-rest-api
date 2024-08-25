# frozen_string_literal: true

RSpec.describe PaypalAPI::ReferencedPayoutItems do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/payments/referenced-payouts-items"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/payments/referenced-payouts-items/%<payouts_item_id>s",
    path_args: {payouts_item_id: "123"}
end
