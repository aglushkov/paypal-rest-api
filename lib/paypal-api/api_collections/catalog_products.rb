# frozen_string_literal: true

module PaypalAPI
  #
  # Merchants can use the Catalog Products API to create products, which are goods and services.
  #
  # @see https://developer.paypal.com/docs/api/catalog-products/v1/
  #
  class CatalogProducts < APICollection
    #
    # Common methods for PaypalAPI::CatalogProducts class and client.catalog_products instance
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # Create product
      #
      # @see https://developer.paypal.com/docs/api/catalog-products/v1/#products_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v1/catalogs/products", query: query, body: body, headers: headers)
      end

      #
      # List products
      #
      # @see https://developer.paypal.com/docs/api/catalog-products/v1/#products_list
      #
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
        client.get("/v1/catalogs/products", query: query, body: body, headers: headers)
      end

      #
      # Show product details
      #
      # @see https://developer.paypal.com/docs/api/catalog-products/v1/#products_get
      #
      # @param product_id [String] Product ID
      # @macro request
      #
      def show(product_id, query: nil, body: nil, headers: nil)
        client.get("/v1/catalogs/products/#{encode(product_id)}", query: query, body: body, headers: headers)
      end

      #
      # Update product
      #
      # @see https://developer.paypal.com/docs/api/catalog-products/v1/#products_patch
      #
      # @param product_id [String] Product ID
      # @macro request
      #
      def update(product_id, query: nil, body: nil, headers: nil)
        client.patch("/v1/catalogs/products/#{encode(product_id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
