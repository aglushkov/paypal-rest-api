# frozen_string_literal: true

RSpec.describe PaypalAPI::InvoiceTemplates do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v2/invoicing/templates"

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v2/invoicing/templates"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v2/invoicing/templates/%<template_id>s",
    path_args: {template_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :put,
    path: "/v2/invoicing/templates/%<template_id>s",
    path_args: {template_id: "123"}

  it_behaves_like "endpoint",
    api_method: :delete,
    http_method: :delete,
    path: "/v2/invoicing/templates/%<template_id>s",
    path_args: {template_id: "123"}
end
