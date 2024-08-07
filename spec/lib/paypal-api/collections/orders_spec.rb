# frozen_string_literal: true

RSpec.describe PaypalAPI::Orders do
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

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :patch,
    path: "/v2/checkout/orders/%<order_id>s",
    path_args: {order_id: "123"}

  it_behaves_like "endpoint",
    api_method: :confirm,
    http_method: :post,
    path: "/v2/checkout/orders/%<order_id>s/confirm-payment-source",
    path_args: {order_id: "123"}

  it_behaves_like "endpoint",
    api_method: :authorize,
    http_method: :post,
    path: "/v2/checkout/orders/%<order_id>s/authorize",
    path_args: {order_id: "123"}

  it_behaves_like "endpoint",
    api_method: :capture,
    http_method: :post,
    path: "/v2/checkout/orders/%<order_id>s/capture",
    path_args: {order_id: "123"}

  it_behaves_like "endpoint",
    api_method: :track,
    http_method: :post,
    path: "/v2/checkout/orders/%<order_id>s/track",
    path_args: {order_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update_tracker,
    http_method: :patch,
    path: "/v2/checkout/orders/%<order_id>s/trackers/%<tracker_id>s",
    path_args: {order_id: "123", tracker_id: "456"}
end
