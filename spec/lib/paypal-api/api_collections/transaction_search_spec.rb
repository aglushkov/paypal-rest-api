# frozen_string_literal: true

RSpec.describe PaypalAPI::TransactionSearch do
  it_behaves_like "endpoint",
    api_method: :list_transactions,
    http_method: :get,
    path: "/v1/reporting/transactions"

  it_behaves_like "endpoint",
    api_method: :list_all_balances,
    http_method: :get,
    path: "/v1/reporting/balances"
end
