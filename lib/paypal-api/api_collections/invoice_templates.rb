# frozen_string_literal: true

module PaypalAPI
  #
  # Manages invoice templates
  #
  # @see https://developer.paypal.com/docs/api/invoicing/v2/
  #
  class InvoiceTemplates < APICollection
    #
    # Common class and instance methods
    #
    module APIs
      # @!macro [new] request
      #   @param query [Hash, nil] Request query parameters
      #   @param body [Hash, nil] Request body parameters
      #   @param headers [Hash, nil] Request headers
      #   @return [Response] Response object

      #
      # Create invoice template
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#templates_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v2/invoicing/templates", query: query, body: body, headers: headers)
      end

      #
      # List templates
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#templates_list
      #
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
        client.get("/v2/invoicing/templates", query: query, body: body, headers: headers)
      end

      #
      # Show template details
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#templates_get
      #
      # @param template_id [String] Template ID
      # @macro request
      #
      def show(template_id, query: nil, body: nil, headers: nil)
        client.get("/v2/invoicing/templates/#{encode(template_id)}", query: query, body: body, headers: headers)
      end

      #
      # Fully update template
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#templates_update
      #
      # @param template_id [String] Template ID
      # @macro request
      #
      def update(template_id, query: nil, body: nil, headers: nil)
        client.put("/v2/invoicing/templates/#{encode(template_id)}", query: query, body: body, headers: headers)
      end

      #
      # Fully update template
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#templates_delete
      #
      # @param template_id [String] Template ID
      # @macro request
      #
      def delete(template_id, query: nil, body: nil, headers: nil)
        client.delete("/v2/invoicing/templates/#{encode(template_id)}", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
