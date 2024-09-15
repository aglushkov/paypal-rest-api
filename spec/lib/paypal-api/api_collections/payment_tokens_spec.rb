# frozen_string_literal: true

RSpec.describe PaypalAPI::PaymentTokens do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v3/vault/payment-tokens"

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v3/vault/payment-tokens"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v3/vault/payment-tokens/%<id>s",
    path_args: {id: "123"}

  it_behaves_like "endpoint",
    api_method: :delete,
    http_method: :delete,
    path: "/v3/vault/payment-tokens/%<id>s",
    path_args: {id: "123"}
end
