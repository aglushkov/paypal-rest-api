# frozen_string_literal: true

RSpec.describe PaypalAPI::Webhooks do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/notifications/webhooks"

  it_behaves_like "endpoint",
    api_method: :delete,
    http_method: :delete,
    path: "/v1/notifications/webhooks/%<webhook_id>s",
    path_args: {webhook_id: "123"}

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v1/notifications/webhooks"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/notifications/webhooks/%<webhook_id>s",
    path_args: {webhook_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :patch,
    path: "/v1/notifications/webhooks/%<webhook_id>s",
    path_args: {webhook_id: "123"}

  it_behaves_like "endpoint",
    api_method: :verify,
    http_method: :post,
    path: "/v1/notifications/verify-webhook-signature"
end
