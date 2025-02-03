# CHANGELOG

## [Unreleased]

- Add Orders V1 APIs (collection is deprecated on PayPal)

## [0.5.1] - 2024-09-30

- Fix links in gem specification

## [0.5.0] - 2024-09-30

- Add PartnerReferrals APIs collection
- Add PaymentExperienceWebProfiles APIs collection
- Add TransactionSearch APIs collection
- Add Response#follow_up_link method to use HATEOAS link
- Add Response#each_page method to iterate over pages
- Add Response#each_page_item(items_field_name) method to iterate over page items

```ruby
  PaypalAPI::WebhookEvents.list(page_size: 25).each_page do |response|
    # ...
  end

  PaypalAPI::WebhookEvents.list(page_size: 25).each_page_item(:events) do |hash|
    # ...
  end
```

## [0.4.0] - 2024-09-16

- Add PaymentToken APIs (and SetupTokens APIs)
- Add json details to FailedRequest error message
- Add CodeClimate badges to README

## [0.3.1] - 2024-09-02

- Fix broken gem build with required `debug` library

## [0.3.0] - 2024-09-02

- Fix UnsupportedMediType errors for requests without body by adding
  content-type "application/json" for all requests

## [0.2.1] - 2024-09-02

- Add missing `PaypalAPI.api_url`, `PaypalAPI.web_url`, `PaypalAPI.live?`,
  `PaypalAPI.sandbox?` methods

## [0.2.0] - 2024-09-02

- Extract environment config to Environment class from Config class
- Add `client.api_url` and `PaypalAPI.api_url` public methods
- Add `client.web_url` and `PaypalAPI.web_url` public methods
- Add `client.live?` and `PaypalAPI.live?` public methods
- Add `client.sandbox?` and `PaypalAPI.sandbox?` public methods

## [0.1.1] - 2024-09-01

- fix callbacks context was nil
- fix `retries[:enabled]` flag was no working when was `false`

## [0.1.0] - 2024-08-30

- Add possibility to verify webhook OFFLINE

  ```ruby
  PaypalAPI.verify_webhook(webhook_id:, headers:, raw_body:)
  ```

- Add callbacks `:before`, `:after_success`, `:after_fail`, `:after_network_error`.
  `context` variable is modifiable as you need and is the same for same request
  between callbacks. Initially context has only :retry_number and :retry_count data.
  On `:after_fail` and `:after_network_error` errors context additionally has `:will_retry`
  boolean field

  ```ruby
  PaypalAPI.client.add_callback(:before) do |request, context|
    context[:request_id] = SecureRandom.hex(3)
    context[:starts_at] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  PaypalAPI.client.add_callback(:after) do |request, context, response|
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
      'PaypalAPI network connection error'
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

## [0.0.4] - 2024-08-25

- Add Payouts & ReferencedPayouts APIs
- Add Invoices APIs
- Add Users management APIs
- Add UserInfo APIs
- Add Disputes APIs

- Split Subscriptions API collection for:
   - Subscriptions
   - SubscriptionPlans

- Split Webhooks API collection for:
   - Webhooks
   - WebhookEvents
   - WebhookLookups

## [0.0.3] - 2024-08-12

- Added `#paypal_request_id` method to errors
- Added Subscriptions APIs
- Added Shipment Tracking APIs
- Added Catalog Products APIs
- Added missing Orders APIs
- Added missing Webhooks APIs
- Added missing Payments APIs
- Split Payments APIs collection to:
   - AuthorizedPayments
      - Payments#show_authorized becomes AuthorizedPayments#show
      - Payments#capture becomes AuthorizedPayments#capture
      - Payments#void becomes AuthorizedPayments#void
   - CapturedPayments
      - Payments#show_captured becomes CapturedPayments#show
      - Payments#refund becomes CapturedPayments#refund
   - Refunds
- Rename errors classes
   - PaypalAPI::FailedRequestError becomes PaypalAPI::Errors::FailedRequest
   - PaypalAPI::NetworkErrorError becomes PaypalAPI::Errors::NetworkError
   - PaypalAPI::BadRequestError becomes PaypalAPI::Errors::BadRequest
   - PaypalAPI::UnauthorizedError becomes PaypalAPI::Errors::Unauthorized
   - PaypalAPI::ForbiddenError becomes PaypalAPI::Errors::Forbidden
   - PaypalAPI::NotFoundError becomes PaypalAPI::Errors::NotFound
   - PaypalAPI::MethodNotAllowedError becomes PaypalAPI::Errors::MethodNotAllowed
   - PaypalAPI::NotAcceptableError becomes PaypalAPI::Errors::NotAcceptable
   - PaypalAPI::ConflictError becomes PaypalAPI::Errors::Conflict
   - PaypalAPI::UnsupportedMediaTypeError becomes PaypalAPI::Errors::UnsupportedMediaType
   - PaypalAPI::UnprocessableEntityError becomes PaypalAPI::Errors::UnprocessableEntity
   - PaypalAPI::TooManyRequestsError becomes PaypalAPI::Errors::TooManyRequests
   - PaypalAPI::FatalError becomes PaypalAPI::Errors::FatalError
   - PaypalAPI::InternalServerError becomes PaypalAPI::Errors::InternalServerError
   - PaypalAPI::ServiceUnavailableError becomes PaypalAPI::Errors::ServiceUnavailable

## [0.0.2] - 2024-08-07

- Add yard documentation
- Rename PaypalAPI::Client.authorization to PaypalAPI::Client.authentication
- Rename PaypalAPI.authorization to PaypalAPI.authentication

## [0.0.1] - 2024-08-06

- Initial release
