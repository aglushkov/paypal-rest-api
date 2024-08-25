# frozen_string_literal: true

RSpec.describe PaypalAPI::PayoutItems do
  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/payments/payouts-item/%<payouts_item_id>s",
    path_args: {payouts_item_id: "123"}

  it_behaves_like "endpoint",
    api_method: :cancel,
    http_method: :post,
    path: "/v1/payments/payouts-item/%<payouts_item_id>s/cancel",
    path_args: {payouts_item_id: "123"}
end
