# frozen_string_literal: true

RSpec.describe PaypalAPI::FailedRequestErrorBuilder do
  data = [
    [Net::HTTPBadRequest, PaypalAPI::Errors::BadRequest].freeze,                     # 400
    [Net::HTTPUnauthorized, PaypalAPI::Errors::Unauthorized].freeze,                 # 401
    [Net::HTTPForbidden, PaypalAPI::Errors::Forbidden].freeze,                       # 403
    [Net::HTTPNotFound, PaypalAPI::Errors::NotFound].freeze,                         # 404
    [Net::HTTPMethodNotAllowed, PaypalAPI::Errors::MethodNotAllowed].freeze,         # 405
    [Net::HTTPNotAcceptable, PaypalAPI::Errors::NotAcceptable].freeze,               # 406
    [Net::HTTPConflict, PaypalAPI::Errors::Conflict].freeze,                         # 409
    [Net::HTTPUnsupportedMediaType, PaypalAPI::Errors::UnsupportedMediaType].freeze, # 415
    [Net::HTTPUnprocessableEntity, PaypalAPI::Errors::UnprocessableEntity].freeze,   # 422
    [Net::HTTPTooManyRequests, PaypalAPI::Errors::TooManyRequests].freeze,           # 429
    [Net::HTTPInternalServerError, PaypalAPI::Errors::InternalServerError].freeze,     # 500
    [Net::HTTPServiceUnavailable, PaypalAPI::Errors::ServiceUnavailable].freeze      # 503
  ].freeze

  let(:request) { "REQUEST" }
  let(:failed_request_error) { "ERROR" }

  before { allow(PaypalAPI::Errors::FailedRequest).to receive(:new).and_return(failed_request_error) }

  def build_http_response(response_class)
    http_response = response_class.allocate
    allow(http_response).to receive_messages(code: "CODE", message: "MESSAGE")
    http_response
  end

  it "converts response to error" do
    data.each do |response_class, error_class|
      http_response = build_http_response(response_class)
      response = PaypalAPI::Response.new(http_response, request: request)

      expect(described_class.call(response: response, request: request)).to equal failed_request_error
      expect(PaypalAPI::Errors::FailedRequest).to have_received(:new).with("CODE MESSAGE", request: request, response: response)
    end
  end

  it "converts unknown http response to error" do
    unknown_http_response_class = Net::HTTPRequestTimeOut # 408
    http_response = build_http_response(unknown_http_response_class)
    response = PaypalAPI::Response.new(http_response, request: request)

    expect(described_class.call(response: response, request: request)).to equal failed_request_error
    expect(PaypalAPI::Errors::FailedRequest).to have_received(:new).with("CODE MESSAGE", request: request, response: response)
  end
end
