# frozen_string_literal: true

RSpec.describe PaypalAPI::ShipmentTracking do
  it_behaves_like "endpoint",
    api_method: :add,
    http_method: :post,
    path: "/v1/shipping/trackers-batch",
    path_args: {}

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :put,
    path: "/v1/shipping/trackers/%<id>s",
    path_args: {id: "123"}

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/shipping/trackers/%<id>s",
    path_args: {id: "123"}
end
