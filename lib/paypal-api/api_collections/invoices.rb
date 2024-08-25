# frozen_string_literal: true

module PaypalAPI
  #
  # Manages invoice templates
  #
  # @see https://developer.paypal.com/docs/api/invoicing/v2/
  #
  class Invoices < APICollection
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
      # Create draft invoice
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_create
      #
      # @macro request
      #
      def create(query: nil, body: nil, headers: nil)
        client.post("/v2/invoicing/invoices", query: query, body: body, headers: headers)
      end

      #
      # List invoices
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_list
      #
      # @macro request
      #
      def list(query: nil, body: nil, headers: nil)
        client.get("/v2/invoicing/invoices", query: query, body: body, headers: headers)
      end

      #
      # Show invoice details
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_get
      # @param invoice_id [String] Invoice ID
      # @macro request
      #
      def show(invoice_id, query: nil, body: nil, headers: nil)
        client.get("/v2/invoicing/invoices/#{encode(invoice_id)}", query: query, body: body, headers: headers)
      end

      #
      # Fully update invoice
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_update
      # @param invoice_id [String] Invoice ID
      # @macro request
      #
      def update(invoice_id, query: nil, body: nil, headers: nil)
        client.put("/v2/invoicing/invoices/#{encode(invoice_id)}", query: query, body: body, headers: headers)
      end

      #
      # Delete invoice
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_delete
      # @param invoice_id [String] Invoice ID
      # @macro request
      #
      def delete(invoice_id, query: nil, body: nil, headers: nil)
        client.delete("/v2/invoicing/invoices/#{encode(invoice_id)}", query: query, body: body, headers: headers)
      end

      #
      # Search for invoices
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_search-invoices
      #
      # @macro request
      #
      def search(query: nil, body: nil, headers: nil)
        client.post("/v2/invoicing/search-invoices", query: query, body: body, headers: headers)
      end

      #
      # Send invoice reminder
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_remind
      # @param invoice_id [String] Invoice ID
      # @macro request
      #
      def remind(invoice_id, query: nil, body: nil, headers: nil)
        client.post("/v2/invoicing/invoices/#{encode(invoice_id)}/remind", query: query, body: body, headers: headers)
      end

      #
      # Delete external refund
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_refunds-delete
      # @param invoice_id [String] Invoice ID
      # @param transaction_id [String] The ID of the external refund transaction to delete.
      # @macro request
      #
      def delete_refund(invoice_id, transaction_id, query: nil, body: nil, headers: nil)
        client.delete(
          "/v2/invoicing/invoices/#{encode(invoice_id)}/refunds/#{encode(transaction_id)}",
          query: query, body: body, headers: headers
        )
      end

      #
      # Delete external payment
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_payment-delete
      # @param invoice_id [String] Invoice ID
      # @param transaction_id [String] The ID of the external payment transaction to delete.
      # @macro request
      #
      def delete_payment(invoice_id, transaction_id, query: nil, body: nil, headers: nil)
        client.delete(
          "/v2/invoicing/invoices/#{encode(invoice_id)}/payments/#{encode(transaction_id)}",
          query: query, body: body, headers: headers
        )
      end

      #
      # Record payment for invoice
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_payments
      # @param invoice_id [String] Invoice ID
      # @macro request
      #
      def record_payment(invoice_id, query: nil, body: nil, headers: nil)
        client.post("/v2/invoicing/invoices/#{encode(invoice_id)}/payments", query: query, body: body, headers: headers)
      end

      #
      # Record refund for invoice
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_refunds
      # @param invoice_id [String] Invoice ID
      # @macro request
      #
      def record_refund(invoice_id, query: nil, body: nil, headers: nil)
        client.post("/v2/invoicing/invoices/#{encode(invoice_id)}/refunds", query: query, body: body, headers: headers)
      end

      #
      # Send invoice
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_send
      # @param invoice_id [String] Invoice ID
      # @macro request
      #
      def send_invoice(invoice_id, query: nil, body: nil, headers: nil)
        client.post("/v2/invoicing/invoices/#{encode(invoice_id)}/send", query: query, body: body, headers: headers)
      end

      #
      # Cancel sent invoice
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_cancel
      # @param invoice_id [String] Invoice ID
      # @macro request
      #
      def cancel(invoice_id, query: nil, body: nil, headers: nil)
        client.post("/v2/invoicing/invoices/#{encode(invoice_id)}/cancel", query: query, body: body, headers: headers)
      end

      #
      # Generate QR code
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_generate-qr-code
      # @param invoice_id [String] Invoice ID
      # @macro request
      #
      def generate_qr_code(invoice_id, query: nil, body: nil, headers: nil)
        client.post("/v2/invoicing/invoices/#{encode(invoice_id)}/generate-qr-code", query: query, body: body, headers: headers)
      end

      #
      # Generate invoice number
      #
      # @see https://developer.paypal.com/docs/api/invoicing/v2/#invoices_generate-next-invoice-number
      # @macro request
      #
      def generate_invoice_number(query: nil, body: nil, headers: nil)
        client.post("/v2/invoicing/generate-next-invoice-number", query: query, body: body, headers: headers)
      end
    end

    include APIs
    extend APIs
  end
end
