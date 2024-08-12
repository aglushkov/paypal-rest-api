# frozen_string_literal: true

RSpec.describe PaypalAPI::AuthorizedPayments do
  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v2/payments/authorizations/%<authorization_id>s",
    path_args: {authorization_id: "123"}

  it_behaves_like "endpoint",
    api_method: :capture,
    http_method: :post,
    path: "/v2/payments/authorizations/%<authorization_id>s/capture",
    path_args: {authorization_id: "123"}

  it_behaves_like "endpoint",
    api_method: :reauthorize,
    http_method: :post,
    path: "/v2/payments/authorizations/%<authorization_id>s/reauthorize",
    path_args: {authorization_id: "123"}

  it_behaves_like "endpoint",
    api_method: :void,
    http_method: :post,
    path: "/v2/payments/authorizations/%<authorization_id>s/void",
    path_args: {authorization_id: "123"}
end
