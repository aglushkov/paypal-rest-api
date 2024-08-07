# frozen_string_literal: true

RSpec.describe PaypalAPI::CatalogProducts do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v1/catalogs/products"

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v1/catalogs/products"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/catalogs/products/%<product_id>s",
    path_args: {product_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :patch,
    path: "/v1/catalogs/products/%<product_id>s",
    path_args: {product_id: "123"}
end
