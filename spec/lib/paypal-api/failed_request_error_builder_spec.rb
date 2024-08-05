# frozen_string_literal: true

RSpec.describe PaypalAPI::FailedRequestErrorBuilder do
  data = [
    [Net::HTTPBadRequest, PaypalAPI::BadRequestError].freeze,                     # 400
    [Net::HTTPUnauthorized, PaypalAPI::UnauthorizedError].freeze,                 # 401
    [Net::HTTPForbidden, PaypalAPI::ForbiddenError].freeze,                       # 403
    [Net::HTTPNotFound, PaypalAPI::NotFoundError].freeze,                         # 404
    [Net::HTTPMethodNotAllowed, PaypalAPI::MethodNotAllowedError].freeze,         # 405
    [Net::HTTPNotAcceptable, PaypalAPI::NotAcceptableError].freeze,               # 406
    [Net::HTTPConflict, PaypalAPI::ConflictError].freeze,                         # 409
    [Net::HTTPUnsupportedMediaType, PaypalAPI::UnsupportedMediaTypeError].freeze, # 415
    [Net::HTTPUnprocessableEntity, PaypalAPI::UnprocessableEntityError].freeze,   # 422
    [Net::HTTPTooManyRequests, PaypalAPI::TooManyRequestsError].freeze,           # 429
    [Net::HTTPInternalServerError, PaypalAPI::InternalServerError].freeze,        # 500
    [Net::HTTPServiceUnavailable, PaypalAPI::ServiceUnavailableError].freeze      # 503
  ].freeze

  let(:request) { "REQUEST" }
  let(:failed_request_error) { "ERROR" }

  before { allow(PaypalAPI::FailedRequest).to receive(:new).and_return(failed_request_error) }

  def build_http_response(response_class)
    http_response = response_class.allocate
    allow(http_response).to receive_messages(code: "CODE", message: "MESSAGE")
    http_response
  end

  it "converts response to error" do
    data.each do |response_class, error_class|
      http_response = build_http_response(response_class)
      response = PaypalAPI::Response.new(http_response, requested_at: nil)

      expect(described_class.call(response: response, request: request)).to equal failed_request_error
      expect(PaypalAPI::FailedRequest).to have_received(:new).with("CODE MESSAGE", request: request, response: response)
    end
  end

  it "converts unknown http response to error" do
    unknown_http_response_class = Net::HTTPRequestTimeOut # 408
    http_response = build_http_response(unknown_http_response_class)
    response = PaypalAPI::Response.new(http_response, requested_at: nil)

    expect(described_class.call(response: response, request: request)).to equal failed_request_error
    expect(PaypalAPI::FailedRequest).to have_received(:new).with("CODE MESSAGE", request: request, response: response)
  end
end
