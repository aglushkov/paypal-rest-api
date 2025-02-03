# frozen_string_literal: true

RSpec.describe PaypalAPI::OrdersV1 do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/checkout/orders",
    path_args: {}

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/checkout/orders/%<order_id>s",
    path_args: {order_id: "123"}

  it_behaves_like "endpoint",
    api_method: :cancel,
    http_method: :delete,
    path: "/v1/checkout/orders/%<order_id>s",
    path_args: {order_id: "123"}

  it_behaves_like "endpoint",
    api_method: :pay,
    http_method: :post,
    path: "/v1/checkout/orders/%<order_id>s/pay",
    path_args: {order_id: "123"}
end
