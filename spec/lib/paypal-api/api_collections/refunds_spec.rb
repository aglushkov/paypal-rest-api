# frozen_string_literal: true

RSpec.describe PaypalAPI::Refunds do
  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v2/payments/refunds/%<refund_id>s",
    path_args: {refund_id: "123"}
end
