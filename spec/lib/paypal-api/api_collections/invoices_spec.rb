# frozen_string_literal: true

RSpec.describe PaypalAPI::Invoices do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v2/invoicing/invoices"

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v2/invoicing/invoices"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v2/invoicing/invoices/%<invoice_id>s",
    path_args: {invoice_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :put,
    path: "/v2/invoicing/invoices/%<invoice_id>s",
    path_args: {invoice_id: "123"}

  it_behaves_like "endpoint",
    api_method: :delete,
    http_method: :delete,
    path: "/v2/invoicing/invoices/%<invoice_id>s",
    path_args: {invoice_id: "123"}

  it_behaves_like "endpoint",
    api_method: :search,
    http_method: :post,
    path: "/v2/invoicing/search-invoices"

  it_behaves_like "endpoint",
    api_method: :remind,
    http_method: :post,
    path: "/v2/invoicing/invoices/%<invoice_id>s/remind",
    path_args: {invoice_id: "123"}

  it_behaves_like "endpoint",
    api_method: :delete_refund,
    http_method: :delete,
    path: "/v2/invoicing/invoices/%<invoice_id>s/refunds/%<transaction_id>s",
    path_args: {invoice_id: "123", transaction_id: "456"}

  it_behaves_like "endpoint",
    api_method: :delete_payment,
    http_method: :delete,
    path: "/v2/invoicing/invoices/%<invoice_id>s/payments/%<transaction_id>s",
    path_args: {invoice_id: "123", transaction_id: "456"}

  it_behaves_like "endpoint",
    api_method: :record_refund,
    http_method: :post,
    path: "/v2/invoicing/invoices/%<invoice_id>s/refunds",
    path_args: {invoice_id: "123"}

  it_behaves_like "endpoint",
    api_method: :record_payment,
    http_method: :post,
    path: "/v2/invoicing/invoices/%<invoice_id>s/payments",
    path_args: {invoice_id: "123"}

  it_behaves_like "endpoint",
    api_method: :send_invoice,
    http_method: :post,
    path: "/v2/invoicing/invoices/%<invoice_id>s/send",
    path_args: {invoice_id: "123"}

  it_behaves_like "endpoint",
    api_method: :cancel,
    http_method: :post,
    path: "/v2/invoicing/invoices/%<invoice_id>s/cancel",
    path_args: {invoice_id: "123"}

  it_behaves_like "endpoint",
    api_method: :generate_qr_code,
    http_method: :post,
    path: "/v2/invoicing/invoices/%<invoice_id>s/generate-qr-code",
    path_args: {invoice_id: "123"}

  it_behaves_like "endpoint",
    api_method: :generate_invoice_number,
    http_method: :post,
    path: "/v2/invoicing/generate-next-invoice-number"
end
