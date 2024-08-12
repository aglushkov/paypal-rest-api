# frozen_string_literal: true

RSpec.describe PaypalAPI::WebhookEvents do
  it_behaves_like "endpoint",
    api_method: :available,
    http_method: :get,
    path: "/v1/notifications/webhooks-event-types"

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v1/notifications/webhooks-events"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/notifications/webhooks-events/%<event_id>s",
    path_args: {event_id: "123"}

  it_behaves_like "endpoint",
    api_method: :resend,
    http_method: :post,
    path: "/v1/notifications/webhooks-events/%<event_id>s/resend",
    path_args: {event_id: "123"}

  it_behaves_like "endpoint",
    api_method: :simulate,
    http_method: :post,
    path: "/v1/notifications/simulate-event"
end
