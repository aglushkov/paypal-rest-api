# frozen_string_literal: true

RSpec.describe PaypalAPI::RequestExecutor do
  subject(:execute) { described_class.call(request) }

  let(:request) do
    instance_double(
      PaypalAPI::Request,
      client: client,
      http_request: http_request,
      requested_at: Time.now,
      "requested_at=": Time.now
    )
  end

  let(:client) { instance_double(PaypalAPI::Client, config: config) }
  let(:http_request) { Net::HTTP::Get.new(URI("https://example.com")) }

  let(:retries_enabled) { false }
  let(:retries_count) { 3 }
  let(:retries_sleep) { [0] }
  let(:config) do
    instance_double(
      PaypalAPI::Config,
      http_opts: {},
      retries: {enabled: retries_enabled, sleep: retries_sleep, count: retries_count}
    )
  end

  context "with success request" do
    before { stub_request(:get, "https://example.com/").to_return(status: 200) }

    it "returns response" do
      expect(execute).to be_a PaypalAPI::Response
    end
  end

  context "with network error happening during request" do
    let(:retries_enabled) { true }

    PaypalAPI::NetworkErrorBuilder::ERRORS.each do |error_class|
      context "with #{error_class} error" do
        before do
          allow(Net::HTTP).to receive(:start).and_raise(error_class)
        end

        it "retries request" do
          expect { execute }.to raise_error PaypalAPI::NetworkError
          expect(Net::HTTP).to have_received(:start).exactly(retries_count + 1).times
        end
      end
    end
  end

  context "with 409, 429, 5** request error happening during request" do
    let(:retries_enabled) { true }

    {
      409 => PaypalAPI::ConflictError,
      429 => PaypalAPI::TooManyRequestsError,
      500 => PaypalAPI::InternalServerError,
      503 => PaypalAPI::ServiceUnavailableError
    }.each do |code, error_class|
      context "with #{code} error" do
        before { stub_request(:get, "https://example.com/").to_return(status: code) }

        it "retries request" do
          expect { execute }.to raise_error error_class
          expect(a_request(:get, "https://example.com/")).to have_been_made.times(retries_count + 1)
        end
      end
    end
  end

  context "with 4xx errors (except 401, 409 and 429)" do
    let(:retries_enabled) { true }

    {
      400 => PaypalAPI::BadRequestError,
      403 => PaypalAPI::ForbiddenError,
      404 => PaypalAPI::NotFoundError,
      405 => PaypalAPI::MethodNotAllowedError,
      406 => PaypalAPI::NotAcceptableError,
      415 => PaypalAPI::UnsupportedMediaTypeError,
      422 => PaypalAPI::UnprocessableEntityError
    }.each do |code, error_class|
      context "with #{code} error" do
        before { stub_request(:get, "https://example.com/").to_return(status: code) }

        it "raises error without retries" do
          expect { execute }.to raise_error error_class
          expect(a_request(:get, "https://example.com/")).to have_been_made.times(1)
        end
      end
    end
  end

  context "with 401 error" do
    let(:retries_enabled) { true }
    let(:access_token) { instance_double(PaypalAPI::AccessToken, authorization_string: "abc") }

    before do
      stub_request(:get, "https://example.com/").to_return(status: 401)
      allow(client).to receive(:refresh_access_token).and_return(access_token)
    end

    it "refreshes access token and retries request" do
      expect { execute }.to raise_error PaypalAPI::UnauthorizedError

      # first request
      expect(a_request(:get, "https://example.com/")).to have_been_made.times(retries_count + 1)

      # retry requests with new authorization
      expect(a_request(:get, "https://example.com/").with(headers: {"authorization" => "abc"}))
        .to have_been_made.times(retries_count)
    end
  end

  context "with 401 error on authorization call" do
    let(:retries_enabled) { true }
    let(:http_request) { Net::HTTP::Get.new(URI.join("https://example.com", PaypalAPI::Authentication::PATH)) }

    before do
      stub_request(:get, /#{PaypalAPI::Authentication::PATH}/o).to_return(status: 401)
    end

    it "returns error without retries" do
      expect { execute }.to raise_error PaypalAPI::UnauthorizedError
      expect(a_request(:get, /#{PaypalAPI::Authentication::PATH}/o)).to have_been_made.times(1)
    end
  end
end
