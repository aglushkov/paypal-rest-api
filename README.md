[![Gem Version](https://badge.fury.io/rb/paypal-rest-api.svg)](https://badge.fury.io/rb/paypal-rest-api)
[![GitHub Actions](https://github.com/aglushkov/paypal-rest-api/actions/workflows/main.yml/badge.svg?event=push)](https://github.com/aglushkov/paypal-rest-api/actions/workflows/main.yml)
[![Test Coverage](https://api.codeclimate.com/v1/badges/11efd530f1df171dac2b/test_coverage)](https://codeclimate.com/github/aglushkov/paypal-rest-api/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/11efd530f1df171dac2b/maintainability)](https://codeclimate.com/github/aglushkov/paypal-rest-api/maintainability)

# PaypalAPI

## Installation

```bash
bundle add paypal-rest-api
```

## Features

- Supported Ruby Versions - *(2.6 .. 3.3), head, jruby-9.4, truffleruby-24*
- No dependencies;
- Automatic authorization & re-authorization;
- Auto-retries (configured);
- Automatically added Paypal-Request-Id header for idempotent requests if not
  provided;
- Webhooks Offline verification (needs to download certificate once)
- Custom callbacks before/after request
- Automatic pagination methods

## Usage

```ruby
# in config/initializers/paypal_rest_api.rb
PaypalAPI.client = PaypalAPI::Client.new(
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET'],
  live: ENV['PAYPAL_LIVE'] == 'true'
)

# Use this API to create order
PaypalAPI::Orders.create(body: body, headers: {prefer: 'return=representation'})

# After customer approves order, we can tell PayPal to authorize it
PaypalAPI::Orders.authorize(order_id)

# After PayPal authorizes order, we can capture it
PaypalAPI::AuthorizedPayments.capture(authorization_id)

# After payment was captured, we can refund it
PaypalAPI::CapturedPayments.refund(capture_id, body: payload, headers: headers)

# Use this APIs to register/actualize PayPal Webhooks
PaypalAPI::Webhooks.list
PaypalAPI::Webhooks.create(body: body)
PaypalAPI::Webhooks.update(webhook_id, body: body)
PaypalAPI::Webhooks.delete(webhook_id)
```

### Per-request Configuration

```ruby
# Anywhere in your business logic
client = PaypalAPI::Client.new(
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET'],
  live: ENV['PAYPAL_LIVE'] == 'true'
)

# Show order
client.orders.show(order_id)

# Create order
client.orders.create(body: body)
```

### Custom requests

If you want to request some undocumented APIs (or some forgotten API):

```ruby
response = PaypalAPI.post(path, query: query, body: body, headers: headers)
response = PaypalAPI.get(path, query: query, body: body, headers: headers)
response = PaypalAPI.patch(path, query: query, body: body, headers: headers)
response = PaypalAPI.put(path, query: query, body: body, headers: headers)
response = PaypalAPI.delete(path, query: query, body: body, headers: headers)

# Or, using per-request client:
response = client.post(path, query: query, body: body, headers: headers)
response = client.get(path, query: query, body: body, headers: headers)
response = client.patch(path, query: query, body: body, headers: headers)
response = client.put(path, query: query, body: body, headers: headers)
response = client.delete(path, query: query, body: body, headers: headers)
```

### Environment helpers

```ruby
PaypalAPI.client = PaypalAPI::Client.new(
  live: ENV['PAYPAL_LIVE'] == 'true',
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET']
)

PaypalAPI.live? # => false
PaypalAPI.sandbox? # => true
PaypalAPI.api_url # => "https://api-m.sandbox.paypal.com"
PaypalAPI.web_url # => "https://sandbox.paypal.com"
```

### Response

`Response` object is returned after each `API` request.

#### Original HTTP response data

- `response.http_status` - response HTTP status as Integer
- `response.http_body` - response body as String
- `response.http_headers` - response headers as Hash with String keys
- `response.http_response` - original Net::HTTP::Response object
- `response.request` - Request object that was used to get this response

#### Parsed JSON body methods

- `response.body` - parsed JSON body, keys are Symbols
- `response[:field]` - gets `:field` attribute from parsed body,
  returns nil if response have no such key
- `response.fetch(:field)` - gets `:field` attribute from parsed body,
  raises KeyError if response has no such key

#### Error check methods

- `response.success?` - checks HTTP status code is 2xx
- `response.failed?` - checks HTTP status code is not 2xx

#### Using HATEOAS links

- `response.follow_up_link('approve', query: nil, body: nil, headers: nil)` -
  Finds HATEOAS link is response with `rel=approve` and requests it. Returns
  `nil` if no such link were found.

#### Pagination (see [Automatic Pagination][automatic_pagination] for examples)

- `response.each_page { |response| ... }` - iterates over each page in response
- `response.each_page_item(items_field) { |item| ... }` - iterates over each
  page item

## Configuration options

PaypalAPI client accepts this additional options:

- `:live`
- `:retries`
- `:http_opts`
- `:cache`

### Option `:live`

PaypalAPI client can be defined with `live` option which is `false` by default.
When `live` is `false` all requests will be send to the sandbox endpoints.

```ruby
client = PaypalAPI::Client.new(
  live: ENV['PAYPAL_LIVE'] == 'true'
  # ...
)
```

### Option `:retries`

This is a Hash with retries configuration.
By default retries are enabled, 4 retries with 0, 0.25, 0.75, 1.5 seconds delay.
Default config: `{enabled: true, count: 4, sleep: [0, 0.25, 0.75, 1.5]}`.
New options are merged with defaults.
Please keep `sleep` array same size as `count`.

Retries happen on any network error, on 409, 429, 5xx response status code.

```ruby
client = PaypalAPI::Client.new(
  retries: {enabled: !Rails.env.test?, count: 5, sleep: [0, 0.25, 0.75, 1.5, 2]}
  # ...
)
```

### Option `:http_opts`

This are the options that are provided to the `Net::HTTP.start` method,
like `:read_timeout`, `:write_timeout`, etc.

You can find full list of available options here <https://docs.ruby-lang.org/en/master/Net/HTTP.html#method-c-start>
(Please choose you version of ruby).

By default it is an empty hash.

```ruby
client = PaypalAPI::Client.new(
  http_opts: {read_timeout: 30, write_timeout: 30, open_timeout: 30}
  # ...
)
```

### Option `:cache`

This option can be added to save webhook-validating certificates between
redeploys to validate webhooks offline. By default this gem has only in-memory
caching. The `cache` object must respond to standard for caching `#fetch` method.

By default it is `nil`, so downloaded certificates will be downloaded again after
redeploys.

```ruby
client = PaypalAPI::Client.new(
  cache: Rails.cache
  # ...
)
```

## Automatic pagination

PayPal provides HATEOAS links in responses. This links can contain items with
`rel=next` attribute. We request next pages using this links.

We have two specific methods:

- `Response#each_page` - iterates over each page `Response` object
- `Response#each_page_item(items_field_name)` - iterates over items on each page

Example:

```ruby
  PaypalAPI::WebhookEvents.list(page_size: 25).each_page do |response|
    # ...
  end

  PaypalAPI::WebhookEvents.list(page_size: 25).each_page_item(:events) do |hash|
    # ...
  end
```

## Webhoooks verification

Webhooks can be verified [offline](https://developer.paypal.com/api/rest/webhooks/rest/#link-selfverificationmethod)
or [online](https://developer.paypal.com/api/rest/webhooks/rest/#link-postbackmethod).
Method `PaypalAPI.verify_webhook(webhook_id:, headers:, raw_body:)`
verifies webhook. It verifies webhook OFFLINE and fallbacks
to ONLINE if initial verification returns false to be sure you don't miss a
valid webhook.

When some required header is missing the
`PaypalAPI::WebhooksVerifier::MissingHeader` error will be raised.

Example of a Rails controller with a webhook verification:

```ruby
class Webhooks::PaypalController < ApplicationController
  def create
    # PayPal registered webhook ID for current URL
    webhook_id = ENV['PAYPAL_WEBHOOK_ID']
    headers = request.headers # must be a Hash
    raw_body = request.raw_post # must be a raw String body

    webhook_is_valid = PaypalAPI.verify_webhook(
      webhook_id: webhook_id,
      headers: headers,
      raw_body: raw_body
    )

    if webhook_is_valid
      handle_valid_webhook_event(body)
    else
      handle_invalid_webhook_event(webhook_id, headers, body)
    end

    head :no_content
  end
end
```

## Callbacks

Paypal::API client allows to subscribe to this callbacks:

- `:before` - Runs before request
- `:after_success` - Runs after getting successful response
- `:after_fail` - Runs after getting failed response (non-2xx) status code
- `:after_network_error` - Runs after getting network error

Each callback receive `request` and `context` variables.
`context` can be modified manually to save state between callbacks.

Arguments:

- `:before` - (request, context)
- `:after_success` - (request, context, response)
- `:after_fail` - (request, context, response)
- `:after_network_error` - (request, context, error)

`Context` argument contains `retries_enabled`, `retries_count` and
`retry_number` options by default. 
On `:after_fail` and `:after_network_error` there are also the
`:will_retry` boolean option.

Examples:

```ruby
PaypalAPI.client.add_callback(:before) do |request, context|
  context[:request_id] = SecureRandom.hex(3)
  context[:starts_at] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
end

PaypalAPI.client.add_callback(:after_success) do |request, context, response|
  ends_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  duration = ends_at - context[:starts_at]

  SomeLogger.debug(
    'PaypalAPI success request',
    method: request.method,
    uri: request.uri.to_s,
    duration: duration
  )
end

PaypalAPI.client.add_callback(:after_fail) do |request, context, response|
  SomeLogger.error(
    'PaypalAPI request failed',
    method: request.method,
    uri: request.uri.to_s,
    response_status: response.http_status,
    response_body: response.http_body,
    will_retry: context[:will_retry],
    retry_number: context[:retry_number],
    retry_count: context[:retry_count]
  )
end

PaypalAPI.client.add_callback(:after_network_error) do |request, context, error|
  SomeLogger.error(
    'PaypalAPI network connection error',
    method: request.method,
    uri: request.uri.to_s,
    error: error.message,
    paypal_request_id: request.headers['paypal-request-id'],
    will_retry: context[:will_retry],
    retry_number: context[:retry_number],
    retry_count: context[:retry_count]
  )
end
```

## Errors

All APIs can raise error in case of network error or non-2xx response status code.

Errors structure:

- `PaypalAPI::Error`
   - `PaypalAPI::Errors::NetworkError` - any network error
   - `PaypalAPI::Errors::FailedRequest` - any non-2xx code error
      - 400 - `PaypalAPI::Errors::BadRequest`
      - 401 - `PaypalAPI::Errors::Unauthorized`
      - 403 - `PaypalAPI::Errors::Forbidden`
      - 404 - `PaypalAPI::Errors::NotFound`
      - 405 - `PaypalAPI::Errors::MethodNotAllowed`
      - 406 - `PaypalAPI::Errors::NotAcceptable`
      - 409 - `PaypalAPI::Errors::Conflict`
      - 415 - `PaypalAPI::Errors::UnsupportedMediaType`
      - 422 - `PaypalAPI::Errors::UnprocessableEntity`
      - 429 - `PaypalAPI::Errors::TooManyRequests`
      - 5xx - `PaypalAPI::Errors::FatalError`
         - 500 - `PaypalAPI::Errors::InternalServerError`
         - 503 - `PaypalAPI::Errors::ServiceUnavailable`

All errors have additional methods:

- `#paypal_request_id` - PayPal-Request-Id header sent with request
- `#response` - Original response object, can be nil in case of NetworkError
- `#request` - Original request object
- `#error_name` - Original error name
- `#error_message` - Original PayPal error `:message` or error `:description`
- `#error_debug_id` - Paypal debug_id found in response
- `#error_details` - Parsed PayPal error details found in parsed response
  (with symbolized keys)

```ruby
begin
  response = PaypalAPI.authorized_payments.capture(authorization_id, body: body)
rescue PaypalAPI::Error => error
  YourLogger.error(
    error,
    context: {
      paypal_request_id: error.paypal_request_id,
      error_name: error.error_name,
      error_message: error.error_message,
      error_debug_id: error.error_debug_id,
      error_details: error.error_details
    }
  )
  # `error.request` and `error.response` methods can be used also
end

```

## APIs

All API endpoints accept `query:`, `body:` and `headers:` **optional** **keyword**
**Hash** parameters. So this parameters can be omitted in next docs.

- `query` - Hash with request query params
- `body` - Hash with request body params
- `headers` - Hash with request headers

### Add tracking / Shipment Tracking [docs](https://developer.paypal.com/docs/api/tracking/v1/)

- `PaypalAPI::ShipmentTracking.add(body: body)`
- `PaypalAPI::ShipmentTracking.update(id, body: body)`
- `PaypalAPI::ShipmentTracking.show(id)`

### Catalog Products [docs](https://developer.paypal.com/docs/api/catalog-products/v1/)

- `PaypalAPI::CatalogProducts.create(body: body)`
- `PaypalAPI::CatalogProducts.list`
- `PaypalAPI::CatalogProducts.show(product_id)`
- `PaypalAPI::CatalogProducts.update(product_id, body: body)`

### Disputes [docs](https://developer.paypal.com/docs/api/customer-disputes/v1/)

- `PaypalAPI::Disputes.settle(id)`
- `PaypalAPI::Disputes.update_status(id)`
- `PaypalAPI::Disputes.escalate(id)`
- `PaypalAPI::Disputes.accept_offer(id)`
- `PaypalAPI::Disputes.list`
- `PaypalAPI::Disputes.provide_supporting_info(id)`
- `PaypalAPI::Disputes.show(id)`
- `PaypalAPI::Disputes.update(id)`
- `PaypalAPI::Disputes.deny_offer(id)`
- `PaypalAPI::Disputes.make_offer(id)`
- `PaypalAPI::Disputes.appeal(id)`
- `PaypalAPI::Disputes.provide_evidence(id)`
- `PaypalAPI::Disputes.acknowledge_return_item`
- `PaypalAPI::Disputes.send_message(id)`
- `PaypalAPI::Disputes.accept_claim`(id)

### Identity [docs](https://developer.paypal.com/docs/api/identity/v1/)

#### User Info

- `PaypalAPI::UserInfo.show`

#### User Management

- `PaypalAPI::Users.create`
- `PaypalAPI::Users.list`
- `PaypalAPI::Users.update(id)`
- `PaypalAPI::Users.show(id)`
- `PaypalAPI::Users.delete(id)`

### Invoicing (Invoices & Invoice Templates) [docs](https://developer.paypal.com/docs/api/invoicing/v2/)

- `PaypalAPI::Invoices.create`
- `PaypalAPI::Invoices.list`
- `PaypalAPI::Invoices.send_invoice(invoice_id)`
- `PaypalAPI::Invoices.remind(invoice_id)`
- `PaypalAPI::Invoices.cancel(invoice_id)`
- `PaypalAPI::Invoices.record_payment(invoice_id)`
- `PaypalAPI::Invoices.delete_payment(invoice_id)`
- `PaypalAPI::Invoices.record_refund(invoice_id)`
- `PaypalAPI::Invoices.delete_refund(invoice_id)`
- `PaypalAPI::Invoices.generate_qr_code(invoice_id)`
- `PaypalAPI::Invoices.generate_invoice_number`
- `PaypalAPI::Invoices.show(invoice_id)`
- `PaypalAPI::Invoices.update(invoice_id)`
- `PaypalAPI::Invoices.delete(invoice_id)`
- `PaypalAPI::Invoices.search`

<!-- -->

- `PaypalAPI::InvoiceTemplates.create`
- `PaypalAPI::InvoiceTemplates.list`
- `PaypalAPI::InvoiceTemplates.show(template_id)`
- `PaypalAPI::InvoiceTemplates.update(template_id)`
- `PaypalAPI::InvoiceTemplates.delete(template_id)`

### Orders [docs](https://developer.paypal.com/docs/api/orders/v2/)

- `PaypalAPI::Orders.create`
- `PaypalAPI::Orders.show(order_id)`
- `PaypalAPI::Orders.update(order_id)`
- `PaypalAPI::Orders.confirm(order_id)`
- `PaypalAPI::Orders.authorize(order_id)`
- `PaypalAPI::Orders.capture(order_id)`
- `PaypalAPI::Orders.track(order_id)`
- `PaypalAPI::Orders.update_tracker(order_id, tracker_id)`

### PartnerReferrals [docs](https://developer.paypal.com/docs/api/partner-referrals/v2/)

- `PaypalAPI::PartnerReferrals.create`
- `PaypalAPI::PartnerReferrals.show(partner_referral_id)`

### Payment Experience Web Profiles [docs](https://developer.paypal.com/docs/api/payment-experience/v1/)

- `PaypalAPI::PaymentExperienceWebProfiles.create`
- `PaypalAPI::PaymentExperienceWebProfiles.list`
- `PaypalAPI::PaymentExperienceWebProfiles.show`
- `PaypalAPI::PaymentExperienceWebProfiles.replace`
- `PaypalAPI::PaymentExperienceWebProfiles.update`
- `PaypalAPI::PaymentExperienceWebProfiles.delete`

### Payment Method Tokens / Setup Tokens [docs](https://developer.paypal.com/docs/api/payment-tokens/v3/)

- `PaypalAPI::PaymentTokens.create`
- `PaypalAPI::PaymentTokens.list`
- `PaypalAPI::PaymentTokens.show(id)`
- `PaypalAPI::PaymentTokens.delete(id)`

<!-- -->

- `PaypalAPI::SetupTokens.create`
- `PaypalAPI::SetupTokens.show(setup_token_id)`

### Payments (Authorized Payments, Captured Payments, Refunds) [docs](https://developer.paypal.com/docs/api/payments/v2/)

- `PaypalAPI::AuthorizedPayments.show(authorization_id)`
- `PaypalAPI::AuthorizedPayments.capture(authorization_id)`
- `PaypalAPI::AuthorizedPayments.reauthorize(authorization_id)`
- `PaypalAPI::AuthorizedPayments.void(authorization_id)`

<!-- -->

- `PaypalAPI::CapturedPayments.show(capture_id)`
- `PaypalAPI::CapturedPayments.refund(capture_id)`

<!-- -->

- `PaypalAPI::Refunds.show(refund_id)`

### Payouts / Payout Items [docs](https://developer.paypal.com/docs/api/payments.payouts-batch/v1/)

- `PaypalAPI::Payouts.create`
- `PaypalAPI::Payouts.show(payout_id)`

<!-- -->

- `PaypalAPI::PayoutItems.show(payout_item_id)`
- `PaypalAPI::PayoutItems.cancel(payout_item_id)`

### Referenced Payouts / Referenced Payout Items [docs](https://developer.paypal.com/docs/api/referenced-payouts/v1/)

- `PaypalAPI::ReferencedPayouts.create`
- `PaypalAPI::ReferencedPayouts.show(payouts_batch_id)`

<!-- -->

- `PaypalAPI::ReferencedPayoutItems.create`
- `PaypalAPI::ReferencedPayoutItems.show(payouts_item_id)`

### Subscriptions / Subscription Plans [docs](https://developer.paypal.com/docs/api/subscriptions/v1/)

- `PaypalAPI::Subscriptions.create`
- `PaypalAPI::Subscriptions.show(id)`
- `PaypalAPI::Subscriptions.update(id)`
- `PaypalAPI::Subscriptions.revise(id)`
- `PaypalAPI::Subscriptions.suspend(id)`
- `PaypalAPI::Subscriptions.cancel(id)`
- `PaypalAPI::Subscriptions.activate(id)`
- `PaypalAPI::Subscriptions.capture(id)`
- `PaypalAPI::Subscriptions.transactions(id)`

<!-- -->

- `PaypalAPI::SubscriptionPlans.create`
- `PaypalAPI::SubscriptionPlans.list`
- `PaypalAPI::SubscriptionPlans.show(plan_id)`
- `PaypalAPI::SubscriptionPlans.update(plan_id)`
- `PaypalAPI::SubscriptionPlans.activate(plan_id)`
- `PaypalAPI::SubscriptionPlans.deactivate(plan_id)`
- `PaypalAPI::SubscriptionPlans.update_pricing(plan_id)`

### Transaction Search [docs](https://developer.paypal.com/docs/api/transaction-search/v1/)

- `PaypalAPI::TransactionSearch.list_transactions`
- `PaypalAPI::TransactionSearch.list_all_balances`

### Webhooks Management [docs](https://developer.paypal.com/docs/api/webhooks/v1/)

- `PaypalAPI::Webhooks.create`
- `PaypalAPI::Webhooks.list`
- `PaypalAPI::Webhooks.show(webhook_id)`
- `PaypalAPI::Webhooks.update(webhook_id)`
- `PaypalAPI::Webhooks.delete(webhook_id)`
- `PaypalAPI::Webhooks.event_types(webhook_id)`
- `PaypalAPI::Webhooks.verify`

<!-- -->

- `PaypalAPI::WebhookEvents.available`
- `PaypalAPI::WebhookEvents.list`
- `PaypalAPI::WebhookEvents.show(event_id)`
- `PaypalAPI::WebhookEvents.resend(event_id)`
- `PaypalAPI::WebhookEvents.simulate`

<!-- -->

- `PaypalAPI::WebhookLookups.create`
- `PaypalAPI::WebhookLookups.list`
- `PaypalAPI::WebhookLookups.show(webhook_lookup_id)`
- `PaypalAPI::WebhookLookups.delete(webhook_lookup_id)`

## Development

```bash
  rubocop
  rspec
  mdl README.md CHANGELOG.md RELEASE.md
```

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/aglushkov/paypal-rest-api>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[automatic_pagination]: #automatic-pagination
