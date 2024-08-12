# frozen_string_literal: true

RSpec.describe PaypalAPI::Subscriptions do
  it_behaves_like "endpoint",
    api_method: :create_plan,
    http_method: :post,
    path: "/v1/billing/plans"

  it_behaves_like "endpoint",
    api_method: :list_plans,
    http_method: :get,
    path: "/v1/billing/plans"

  it_behaves_like "endpoint",
    api_method: :show_plan,
    http_method: :get,
    path: "/v1/billing/plans/%<plan_id>s",
    path_args: {plan_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update_plan,
    http_method: :patch,
    path: "/v1/billing/plans/%<plan_id>s",
    path_args: {plan_id: "123"}

  it_behaves_like "endpoint",
    api_method: :activate_plan,
    http_method: :post,
    path: "/v1/billing/plans/%<plan_id>s/activate",
    path_args: {plan_id: "123"}

  it_behaves_like "endpoint",
    api_method: :deactivate_plan,
    http_method: :post,
    path: "/v1/billing/plans/%<plan_id>s/deactivate",
    path_args: {plan_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update_plan_pricing,
    http_method: :post,
    path: "/v1/billing/plans/%<plan_id>s/update-pricing-schemes",
    path_args: {plan_id: "123"}

  it_behaves_like "endpoint",
    api_method: :create_subscription,
    http_method: :post,
    path: "/v1/billing/subscriptions"

  it_behaves_like "endpoint",
    api_method: :show_subscription,
    http_method: :get,
    path: "/v1/billing/subscriptions/%<subscription_id>s",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update_subscription,
    http_method: :patch,
    path: "/v1/billing/subscriptions/%<subscription_id>s",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :revise_subscription,
    http_method: :post,
    path: "/v1/billing/subscriptions/%<subscription_id>s/revise",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :suspend_subscription,
    http_method: :post,
    path: "/v1/billing/subscriptions/%<subscription_id>s/suspend",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :cancel_subscription,
    http_method: :post,
    path: "/v1/billing/subscriptions/%<subscription_id>s/cancel",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :activate_subscription,
    http_method: :post,
    path: "/v1/billing/subscriptions/%<subscription_id>s/activate",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :capture_subscription,
    http_method: :post,
    path: "/v1/billing/subscriptions/%<subscription_id>s/capture",
    path_args: {subscription_id: "123"}

  it_behaves_like "endpoint",
    api_method: :transactions,
    http_method: :get,
    path: "/v1/billing/subscriptions/%<subscription_id>s/transactions",
    path_args: {subscription_id: "123"}
end
