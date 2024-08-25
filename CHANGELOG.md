# CHANGELOG

## [Unreleased]

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
