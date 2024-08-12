# frozen_string_literal: true

RSpec.describe PaypalAPI::CapturedPayments do
  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v2/payments/captures/%<capture_id>s",
    path_args: {capture_id: "123"}

  it_behaves_like "endpoint",
    api_method: :refund,
    http_method: :post,
    path: "/v2/payments/captures/%<capture_id>s/refund",
    path_args: {capture_id: "123"}
end
