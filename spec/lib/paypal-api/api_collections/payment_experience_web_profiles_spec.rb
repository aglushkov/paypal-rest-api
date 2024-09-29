# frozen_string_literal: true

RSpec.describe PaypalAPI::PaymentExperienceWebProfiles do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/payment-experience/web-profiles"

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v1/payment-experience/web-profiles"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/payment-experience/web-profiles/%<id>s",
    path_args: {id: "123"}

  it_behaves_like "endpoint",
    api_method: :replace,
    http_method: :put,
    path: "/v1/payment-experience/web-profiles/%<id>s",
    path_args: {id: "123"}

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :patch,
    path: "/v1/payment-experience/web-profiles/%<id>s",
    path_args: {id: "123"}

  it_behaves_like "endpoint",
    api_method: :delete,
    http_method: :delete,
    path: "/v1/payment-experience/web-profiles/%<id>s",
    path_args: {id: "123"}
end
