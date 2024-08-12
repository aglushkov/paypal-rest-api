# PaypalAPI

## Installation

```bash
bundle add paypal-rest-api
```

## Features

- No dependencies;
- Automatic authorization & reauthorization;
- Auto-retries (configured);
- Automatically added Paypal-Request-Id header for idempotent requests if not
  provided;

## Usage

- All APIs accept optional `:query`, `:body` and `:headers` keyword parameters.
- Response has `#body` method to get parsed JSON body.
  This body has `symbolized` hash keys.
- Response contains methods to get original HTTP response.
- Failed request error (for non `2**` status codes) contains HTTP request and
  response
- Failed request error (for network errors) contains request and original error

```ruby
# Initiate client
client = PaypalAPI::Client.new(
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET'],
  live: false
)

# Usage example:
response = client.orders.create(body: body)
response = client.orders.show(order_id)
response = client.authorized_payments.capture(authorization_id, headers: headers)
response = client.webhooks.list(query: query)

# Client also can send requests directly, bypassing specific resources methods
response = client.post(path, query: query, body: body, headers: headers)
response = client.get(path, query: query, body: body, headers: headers)
response = client.patch(path, query: query, body: body, headers: headers)
response = client.put(path, query: query, body: body, headers: headers)
response = client.delete(path, query: query, body: body, headers: headers)

# Getting response
response.body # Parsed JSON. JSON is parsed lazyly, keys are symbolized.
response[:foo] # Gets :foo attribute from parsed body
response.fetch(:foo) # Fetches :foo attribute from parsed body
response.http_response # original Net::HTTP::Response
response.http_body # original response string
response.http_status # Integer http status
response.http_headers # Hash with response headers (keys are strings)
response.requested_at # Time when request was sent
```

Also PaypalAPI client can be added globally and class methods can be used instead:

```ruby
# in config/initializers/paypal_api.rb
PaypalAPI.client = PaypalAPI::Client.new(
  client_id: ENV['PAYPAL_CLIENT_ID'],
  client_secret: ENV['PAYPAL_CLIENT_SECRET'],
  live: false
)

# in your business logic
response = PaypalAPI.orders.create(body: body)
response = PaypalAPI.webhooks.verify(body: body)

# same
PaypalAPI::Orders.create(body: body)
PaypalAPI::Webhooks.verify(body: body)

# Also now PaypalAPI class can be used as a client
response = PaypalAPI.post(path, query: query, body: body, headers: headers)
response = PaypalAPI.get(path, query: query, body: body, headers: headers)
response = PaypalAPI.patch(path, query: query, body: body, headers: headers)
response = PaypalAPI.put(path, query: query, body: body, headers: headers)
response = PaypalAPI.delete(path, query: query, body: body, headers: headers)
```

## Configuration options

PaypalAPI client accepts this additional options: `:live`, `:retries`, `:http_opts`

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
By default retries are enabled, 3 retries with 0.25, 0.75, 1.5 seconds delay.
Default config: `{enabled: true, count: 3, sleep: [0.25, 0.75, 1.5]}`.
New options are merged with defaults.
Please keep `sleep` array same size as `count`.

Retries happen on any network error, on 409, 429, 5xx response status code.

```ruby
client = PaypalAPI::Client.new(
  retries: {count: 2, sleep: [0, 0]}
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

### Orders

- `PaypalAPI::Orders.create`
- `PaypalAPI::Orders.show`
- `PaypalAPI::Orders.update`
- `PaypalAPI::Orders.confirm`
- `PaypalAPI::Orders.authorize`
- `PaypalAPI::Orders.capture`
- `PaypalAPI::Orders.track`
- `PaypalAPI::Orders.update_tracker`

### Payments

- `PaypalAPI::AuthorizedPayment.show`
- `PaypalAPI::AuthorizedPayment.capture`
- `PaypalAPI::AuthorizedPayment.reauthorize`
- `PaypalAPI::AuthorizedPayment.void`

<!-- -->

- `PaypalAPI::CapturedPayment.show`
- `PaypalAPI::CapturedPayment.refund`

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

## Development

```bash
  bundle install
  rubocop
  rspec
  mdl README.md CHANGELOG.md RELEASE.md
```

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/aglushkov/paypal-api>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
