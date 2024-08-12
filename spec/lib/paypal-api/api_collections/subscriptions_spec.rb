# frozen_string_literal: true

RSpec.describe PaypalAPI::Subscriptions do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/billing/subscriptions"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/billing/subscriptions/%<subscription_id>s",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :patch,
    path: "/v1/billing/subscriptions/%<subscription_id>s",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :revise,
    http_method: :post,
    path: "/v1/billing/subscriptions/%<subscription_id>s/revise",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :suspend,
    http_method: :post,
    path: "/v1/billing/subscriptions/%<subscription_id>s/suspend",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :cancel,
    http_method: :post,
    path: "/v1/billing/subscriptions/%<subscription_id>s/cancel",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :activate,
    http_method: :post,
    path: "/v1/billing/subscriptions/%<subscription_id>s/activate",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :capture,
    http_method: :post,
    path: "/v1/billing/subscriptions/%<subscription_id>s/capture",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :transactions,
    http_method: :get,
    path: "/v1/billing/subscriptions/%<subscription_id>s/transactions",
    path_args: {subscription_id: "123"}
end
