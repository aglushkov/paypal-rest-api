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

`response.body` is a main method that returns parsed JSON respoonse as a HASH.

There are also many others helpful methods:

```
response.body # Parsed JSON. JSON is parsed lazyly, keys are symbolized.
response[:foo] # Gets :foo attribute from parsed body
response.fetch(:foo) # Fetches :foo attribute from parsed body
response.http_response # original Net::HTTP::Response
response.http_body # original response string
response.http_status # Integer http status
response.http_headers # Hash with response headers (keys are strings)
response.requested_at # Time when request was sent
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
