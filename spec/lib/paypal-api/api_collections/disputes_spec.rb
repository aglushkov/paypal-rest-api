# frozen_string_literal: true

RSpec.describe PaypalAPI::Disputes do
  it_behaves_like "endpoint",
    api_method: :appeal,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/appeal",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :make_offer,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/make-offer",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/customer/disputes/%<dispute_id>s",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :patch,
    path: "/v1/customer/disputes/%<dispute_id>s",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :send_message,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/send-message",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :provide_supporting_info,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/provide-supporting-info",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update_status,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/require-evidence",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :deny_offer,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/deny-offer",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :provide_evidence,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/provide-evidence",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :settle,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/adjudicate",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :acknowledge_return_item,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/acknowledge-return-item",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :accept_claim,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/accept-claim",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v1/customer/disputes"

  it_behaves_like "endpoint",
    api_method: :escalate,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/escalate",
    path_args: {dispute_id: "123"}

  it_behaves_like "endpoint",
    api_method: :accept_offer,
    http_method: :post,
    path: "/v1/customer/disputes/%<dispute_id>s/accept-offer",
    path_args: {dispute_id: "123"}
end
