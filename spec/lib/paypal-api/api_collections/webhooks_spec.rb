# frozen_string_literal: true

RSpec.describe PaypalAPI::Webhooks do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/notifications/webhooks"

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
    api_method: :delete,
    http_method: :delete,
    path: "/v1/notifications/webhooks/%<webhook_id>s",
    path_args: {webhook_id: "123"}

  it_behaves_like "endpoint",
    api_method: :list_event_types,
    http_method: :get,
    path: "/v1/notifications/webhooks/%<webhook_id>s/event-types",
    path_args: {webhook_id: "123"}

  it_behaves_like "endpoint",
    api_method: :create_lookup,
    http_method: :post,
    path: "/v1/notifications/webhooks-lookup"

  it_behaves_like "endpoint",
    api_method: :list_lookups,
    http_method: :get,
    path: "/v1/notifications/webhooks-lookup"

  it_behaves_like "endpoint",
    api_method: :show_lookup,
    http_method: :get,
    path: "/v1/notifications/webhooks-lookup/%<webhook_lookup_id>s",
    path_args: {webhook_lookup_id: "123"}

  it_behaves_like "endpoint",
    api_method: :delete_lookup,
    http_method: :delete,
    path: "/v1/notifications/webhooks-lookup/%<webhook_lookup_id>s",
    path_args: {webhook_lookup_id: "123"}

  it_behaves_like "endpoint",
    api_method: :verify,
    http_method: :post,
    path: "/v1/notifications/verify-webhook-signature"

  it_behaves_like "endpoint",
    api_method: :list_available_events,
    http_method: :get,
    path: "/v1/notifications/webhooks-event-types"

  it_behaves_like "endpoint",
    api_method: :list_events,
    http_method: :get,
    path: "/v1/notifications/webhooks-events"

  it_behaves_like "endpoint",
    api_method: :show_event,
    http_method: :get,
    path: "/v1/notifications/webhooks-events/%<event_id>s",
    path_args: {event_id: "123"}

  it_behaves_like "endpoint",
    api_method: :resend_event,
    http_method: :post,
    path: "/v1/notifications/webhooks-events/%<event_id>s/resend",
    path_args: {event_id: "123"}

  it_behaves_like "endpoint",
    api_method: :simulate_event,
    http_method: :post,
    path: "/v1/notifications/simulate-event"
end
