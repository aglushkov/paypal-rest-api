# frozen_string_literal: true

RSpec.describe PaypalAPI::SubscriptionPlans do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/billing/plans"

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v1/billing/plans"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/billing/plans/%<plan_id>s",
    path_args: {plan_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :patch,
    path: "/v1/billing/plans/%<plan_id>s",
    path_args: {plan_id: "123"}

  it_behaves_like "endpoint",
    api_method: :activate,
    http_method: :post,
    path: "/v1/billing/plans/%<plan_id>s/activate",
    path_args: {plan_id: "123"}

  it_behaves_like "endpoint",
    api_method: :deactivate,
    http_method: :post,
    path: "/v1/billing/plans/%<plan_id>s/deactivate",
    path_args: {plan_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update_pricing,
    http_method: :post,
    path: "/v1/billing/plans/%<plan_id>s/update-pricing-schemes",
    path_args: {plan_id: "123"}
end
