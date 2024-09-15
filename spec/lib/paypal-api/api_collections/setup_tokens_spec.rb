# frozen_string_literal: true

RSpec.describe PaypalAPI::SetupTokens do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v3/vault/setup-tokens"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v3/vault/setup-tokens/%<id>s",
    path_args: {id: "123"}
end
