# frozen_string_literal: true

RSpec.describe PaypalAPI::Payments do
  it_behaves_like "endpoint",
    api_method: :capture,
    http_method: :post,
    path: "/v2/payments/authorizations/%<authorization_id>s/capture",
    path_args: {authorization_id: "123"}

  it_behaves_like "endpoint",
    api_method: :refund,
    http_method: :post,
    path: "/v2/payments/captures/%<capture_id>s/refund",
    path_args: {capture_id: "123"}

  it_behaves_like "endpoint",
    api_method: :show_authorized,
    http_method: :get,
    path: "/v2/payments/authorizations/%<authorization_id>s",
    path_args: {authorization_id: "123"}

  it_behaves_like "endpoint",
    api_method: :show_captured,
    http_method: :get,
    path: "/v2/payments/captures/%<capture_id>s",
    path_args: {capture_id: "123"}

  it_behaves_like "endpoint",
    api_method: :void,
    http_method: :post,
    path: "/v2/payments/authorizations/%<authorization_id>s/void",
    path_args: {authorization_id: "123"}
end
