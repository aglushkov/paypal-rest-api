# frozen_string_literal: true

RSpec.describe PaypalAPI::Payouts do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/payments/payouts"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/payments/payouts/%<payout_batch_id>s",
    path_args: {payout_batch_id: "123"}
end
