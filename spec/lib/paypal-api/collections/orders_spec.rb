# frozen_string_literal: true

RSpec.describe PaypalAPI::Orders do
  it_behaves_like "endpoint",
    api_method: :authorize,
    http_method: :post,
    path: "/v2/checkout/orders/%<order_id>s/authorize",
    path_args: {order_id: "123"}

  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v2/checkout/orders",
    path_args: {}

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v2/checkout/orders/%<order_id>s",
    path_args: {order_id: "123"}
end
