# frozen_string_literal: true

RSpec.describe PaypalAPI::ReferencedPayouts do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/payments/referenced-payouts"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/payments/referenced-payouts/%<payout_batch_id>s",
    path_args: {payout_batch_id: "123"}
end
