# frozen_string_literal: true

RSpec.describe PaypalAPI::WebhookLookups do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/notifications/webhooks-lookup"

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v1/notifications/webhooks-lookup"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/notifications/webhooks-lookup/%<webhook_lookup_id>s",
    path_args: {webhook_lookup_id: "123"}

  it_behaves_like "endpoint",
    api_method: :delete,
    http_method: :delete,
    path: "/v1/notifications/webhooks-lookup/%<webhook_lookup_id>s",
    path_args: {webhook_lookup_id: "123"}
end
