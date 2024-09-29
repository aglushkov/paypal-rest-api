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
- Automatic authorization & reauthorization;
- Auto-retries (configured);
- Automatically added Paypal-Request-Id header for idempotent requests if not
  provided;
- Webhooks Offline verification (needs to download certificate once)
- Custom callbacks before/after request

## Usage

There are two options:

- Setting global client
- Setting local client (for possibility to use multiple PayPal environments)

### Setting global client

```ruby
# in config/initializers/paypal_rest_api.rb
PaypalAPI.client = PaypalAPI::Client.new(
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET'],
  live: false
)

# in your business logic
PaypalAPI.live? # => false
PaypalAPI.api_url # => "https://api-m.sandbox.paypal.com"
PaypalAPI.web_url # => "https://sandbox.paypal.com"

response = PaypalAPI::Orders.show(order_id)
response = PaypalAPI::Orders.create(body: body)
```

### Setting local client

```ruby
# in your business logic
client = PaypalAPI::Client.new(
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET'],
  live: false
)

client.live? # => false
client.api_url # => "https://api-m.sandbox.paypal.com"
client.web_url # => "https://sandbox.paypal.com"

response = client.orders.show(order_id)
response = client.orders.create(body: body)
```

### Client REST methods

Client can call HTTP methods directly:

```ruby
response = client.post(path, query: query, body: body, headers: headers)
response = client.get(path, query: query, body: body, headers: headers)
response = client.patch(path, query: query, body: body, headers: headers)
response = client.put(path, query: query, body: body, headers: headers)
response = client.delete(path, query: query, body: body, headers: headers)

# Or, after setting global client:
response = PaypalAPI.post(path, query: query, body: body, headers: headers)
response = PaypalAPI.get(path, query: query, body: body, headers: headers)
response = PaypalAPI.patch(path, query: query, body: body, headers: headers)
response = PaypalAPI.put(path, query: query, body: body, headers: headers)
response = PaypalAPI.delete(path, query: query, body: body, headers: headers)
```

### Parsing response

`response.body` is a main method that returns parsed JSON respoonse as a Hash.

There are also many others helpful methods:

```ruby
response.body # Parsed JSON. JSON is parsed lazyly, keys are symbolized.
response[:foo] # Gets :foo attribute from parsed body
response.fetch(:foo) # Fetches :foo attribute from parsed body
response.http_response # original Net::HTTP::Response
response.http_body # original response string
response.http_status # Integer http status
response.http_headers # Hash with response headers (keys are strings)
response.request # Request that generates this response
```

## Configuration options

PaypalAPI client accepts this additional options:

- `:live`
- `:retries`,
- `:http_opts`
- `:cache`

### Option `:live`

PaypalAPI client can be defined with `live` option which is `false` by default.
When `live` is `false` all requests will be send to the sandbox endpoints.

```ruby
client = PaypalAPI::Client.new(
  live: true
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

This option can be added to save certificates to between redeploys to validate
webhooks offline. By default this gem has only in-memory caching.
Cache object must response to standard caching `#fetch(key, &block)` method.

By default it is `nil`, so downloaded certificates will be downloaded again after
redeploys.

```ruby
client = PaypalAPI::Client.new(
  cache: Rails.cache
  # ...
)
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

Example of Rails controller with webhook verification:

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

Callbacks list:

- `:before` - Runs before request
- `:after_success` - Runs after getting successful response
- `:after_fail` - Runs after getting failed response (non-2xx) status code
- `:after_network_error` - Runs after getting network error

Callbacks are registered on `client` object.

Each callback receive `request` and `context` variables.
`context` can be modified manually to save state between callbacks.

Arguments:

- `:before` - (request, context)
- `:after_success` - (request, context, response)
- `:after_fail` - (request, context, response)
- `:after_network_error` - (request, context, error)

`Context` argument contains `retries_enabled` and `retries_count` and
`retry_number` keys by default.

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

All API endpoints accept this parameters:

- `resource_id` - Resource ID (Unless `create`/`list` endpoint)
- `query` - Hash with request query params
- `body` - Hash with request body params
- `headers` - Hash with request headers

### Orders

- `PaypalAPI::Orders.create`
- `PaypalAPI::Orders.show`
- `PaypalAPI::Orders.update`
- `PaypalAPI::Orders.confirm`
- `PaypalAPI::Orders.authorize`
- `PaypalAPI::Orders.capture`
- `PaypalAPI::Orders.track`
- `PaypalAPI::Orders.update_tracker`

### Payment Tokens

- `PaypalAPI::PaymentTokens.create`
- `PaypalAPI::PaymentTokens.list`
- `PaypalAPI::PaymentTokens.show`
- `PaypalAPI::PaymentTokens.delete`

<!-- -->

- `PaypalAPI::SetupTokens.create`
- `PaypalAPI::SetupTokens.show`

### Payments

- `PaypalAPI::AuthorizedPayments.show`
- `PaypalAPI::AuthorizedPayments.capture`
- `PaypalAPI::AuthorizedPayments.reauthorize`
- `PaypalAPI::AuthorizedPayments.void`

<!-- -->

- `PaypalAPI::CapturedPayments.show`
- `PaypalAPI::CapturedPayments.refund`

<!-- -->

- `PaypalAPI::Refunds.show`

### Webhooks

- `PaypalAPI::Webhooks.create`
- `PaypalAPI::Webhooks.list`
- `PaypalAPI::Webhooks.show`
- `PaypalAPI::Webhooks.update`
- `PaypalAPI::Webhooks.delete`
- `PaypalAPI::Webhooks.event_types`
- `PaypalAPI::Webhooks.verify`

<!-- -->

- `PaypalAPI::WebhookEvents.available`
- `PaypalAPI::WebhookEvents.list`
- `PaypalAPI::WebhookEvents.show`
- `PaypalAPI::WebhookEvents.resend`
- `PaypalAPI::WebhookEvents.simulate`

<!-- -->

- `PaypalAPI::WebhookLookups.create`
- `PaypalAPI::WebhookLookups.list`
- `PaypalAPI::WebhookLookups.show`
- `PaypalAPI::WebhookLookups.delete`

### Subscriptions

- `PaypalAPI::Subscriptions.create`
- `PaypalAPI::Subscriptions.show`
- `PaypalAPI::Subscriptions.update`
- `PaypalAPI::Subscriptions.revise`
- `PaypalAPI::Subscriptions.suspend`
- `PaypalAPI::Subscriptions.cancel`
- `PaypalAPI::Subscriptions.activate`
- `PaypalAPI::Subscriptions.capture`
- `PaypalAPI::Subscriptions.transactions`

<!-- -->

- `PaypalAPI::SubscriptionPlans.create`
- `PaypalAPI::SubscriptionPlans.list`
- `PaypalAPI::SubscriptionPlans.show`
- `PaypalAPI::SubscriptionPlans.update`
- `PaypalAPI::SubscriptionPlans.activate`
- `PaypalAPI::SubscriptionPlans.deactivate`
- `PaypalAPI::SubscriptionPlans.update_pricing`

### Shipment Tracking

- `PaypalAPI::ShipmentTracking.add`
- `PaypalAPI::ShipmentTracking.update`
- `PaypalAPI::ShipmentTracking.show`

### Catalog Products

- `PaypalAPI::CatalogProducts.create`
- `PaypalAPI::CatalogProducts.list`
- `PaypalAPI::CatalogProducts.show`
- `PaypalAPI::CatalogProducts.update`

### Disputes

- `PaypalAPI::Disputes.appeal`
- `PaypalAPI::Disputes.make_offer`
- `PaypalAPI::Disputes.show`
- `PaypalAPI::Disputes.update`
- `PaypalAPI::Disputes.send_message`
- `PaypalAPI::Disputes.provide_supporting_info`
- `PaypalAPI::Disputes.update_status`
- `PaypalAPI::Disputes.deny_offer`
- `PaypalAPI::Disputes.provide_evidence`
- `PaypalAPI::Disputes.settle`
- `PaypalAPI::Disputes.acknowledge_return_item`
- `PaypalAPI::Disputes.accept_claim`
- `PaypalAPI::Disputes.list`
- `PaypalAPI::Disputes.escalate`
- `PaypalAPI::Disputes.accept_offer`

### UserInfo

- `PaypalAPI::UserInfo.show`

### Users

- `PaypalAPI::Users.create`
- `PaypalAPI::Users.list`
- `PaypalAPI::Users.show`
- `PaypalAPI::Users.update`
- `PaypalAPI::Users.delete`

### Invoices

- `PaypalAPI::Invoices.create`
- `PaypalAPI::Invoices.list`
- `PaypalAPI::Invoices.show`
- `PaypalAPI::Invoices.update`
- `PaypalAPI::Invoices.delete`
- `PaypalAPI::Invoices.search`
- `PaypalAPI::Invoices.remind`
- `PaypalAPI::Invoices.delete_refund`
- `PaypalAPI::Invoices.delete_payment`
- `PaypalAPI::Invoices.record_refund`
- `PaypalAPI::Invoices.record_payment`
- `PaypalAPI::Invoices.send_invoice`
- `PaypalAPI::Invoices.cancel`
- `PaypalAPI::Invoices.generate_qr_code`
- `PaypalAPI::Invoices.generate_invoice_number`

### InvoiceTemplates

- `PaypalAPI::InvoiceTemplates.create`
- `PaypalAPI::InvoiceTemplates.list`
- `PaypalAPI::InvoiceTemplates.show`
- `PaypalAPI::InvoiceTemplates.update`
- `PaypalAPI::InvoiceTemplates.delete`

### Payouts

- `PaypalAPI::Payouts.create`
- `PaypalAPI::Payouts.show`
- `PaypalAPI::PayoutItems.show`
- `PaypalAPI::PayoutItems.cancel`

### ReferencedPayouts

- `PaypalAPI::ReferencedPayouts.create`
- `PaypalAPI::ReferencedPayouts.show`
- `PaypalAPI::ReferencedPayoutItems.create`
- `PaypalAPI::ReferencedPayoutItems.show`

### PartnerReferrals

- `PaypalAPI::PartnerReferrals.create`
- `PaypalAPI::PartnerReferrals.show`

### PaymentExperienceWebProfiles

- `PaypalAPI::PaymentExperienceWebProfiles.create`
- `PaypalAPI::PaymentExperienceWebProfiles.list`
- `PaypalAPI::PaymentExperienceWebProfiles.show`
- `PaypalAPI::PaymentExperienceWebProfiles.replace`
- `PaypalAPI::PaymentExperienceWebProfiles.update`
- `PaypalAPI::PaymentExperienceWebProfiles.delete`

### TransactionSearch

- `PaypalAPI::TransactionSearch.list_transactions`
- `PaypalAPI::TransactionSearch.list_all_balances`

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
