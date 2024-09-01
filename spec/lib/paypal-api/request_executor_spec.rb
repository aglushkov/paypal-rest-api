# frozen_string_literal: true

RSpec.describe PaypalAPI::RequestExecutor do
  subject(:execute) { executer.call }

  let(:request) do
    instance_double(
      PaypalAPI::Request,
      client: client,
      http_request: http_request,
      uri: URI("https://example.com"),
      path: path
    )
  end

  let(:executer) { described_class.new(client, request) }
  let(:client) { instance_double(PaypalAPI::Client, config: config, callbacks: callbacks) }
  let(:http_request) { Net::HTTP::Get.new(uri) }
  let(:path) { "/foo/bar" }
  let(:uri) { URI.join("https://example.com", path) }

  let(:retries_enabled) { false }
  let(:retries_count) { 3 }
  let(:retries_sleep) { [0, 0.0001] }
  let(:config) do
    instance_double(
      PaypalAPI::Config,
      http_opts: {},
      retries: {enabled: retries_enabled, sleep: retries_sleep, count: retries_count}
    )
  end

  let(:callbacks) do
    {
      before: [],
      after_success: [],
      after_fail: [],
      after_network_error: []
    }
  end

  context "with success request" do
    before { stub_request(:get, uri).to_return(status: 200) }

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
          expect { execute }.to raise_error PaypalAPI::Errors::NetworkError
          expect(Net::HTTP).to have_received(:start).exactly(retries_count + 1).times
        end
      end
    end
  end

  context "with unknown error happening during request" do
    let(:retries_enabled) { true }
    let(:error) { StandardError.new }

    context "with unknown error" do
      before do
        allow(Net::HTTP).to receive(:start).and_raise(error)
      end

      it "raises this error" do
        expect { execute }.to raise_error error
      end
    end
  end

  context "with 409, 429, 5** request error happening during request" do
    let(:retries_enabled) { true }

    {
      409 => PaypalAPI::Errors::Conflict,
      429 => PaypalAPI::Errors::TooManyRequests,
      500 => PaypalAPI::Errors::InternalServerError,
      503 => PaypalAPI::Errors::ServiceUnavailable
    }.each do |code, error_class|
      context "with #{code} error" do
        before { stub_request(:get, uri).to_return(status: code) }

        it "retries request" do
          expect { execute }.to raise_error error_class
          expect(a_request(:get, uri)).to have_been_made.times(retries_count + 1)
        end
      end
    end
  end

  context "with 4xx errors (except 401, 409 and 429)" do
    let(:retries_enabled) { true }

    {
      400 => PaypalAPI::Errors::BadRequest,
      403 => PaypalAPI::Errors::Forbidden,
      404 => PaypalAPI::Errors::NotFound,
      405 => PaypalAPI::Errors::MethodNotAllowed,
      406 => PaypalAPI::Errors::NotAcceptable,
      415 => PaypalAPI::Errors::UnsupportedMediaType,
      422 => PaypalAPI::Errors::UnprocessableEntity
    }.each do |code, error_class|
      context "with #{code} error" do
        before { stub_request(:get, uri).to_return(status: code) }

        it "raises error without retries" do
          expect { execute }.to raise_error error_class
          expect(a_request(:get, uri)).to have_been_made.times(1)
        end
      end
    end
  end

  context "with 401 error" do
    let(:retries_enabled) { true }
    let(:access_token) { instance_double(PaypalAPI::AccessToken, authorization_string: "abc") }

    before do
      stub_request(:get, uri).to_return(status: 401)
      allow(client).to receive(:refresh_access_token).and_return(access_token)
    end

    it "refreshes access token and retries request" do
      expect { execute }.to raise_error PaypalAPI::Errors::Unauthorized

      # first request
      expect(a_request(:get, uri)).to have_been_made.times(retries_count + 1)

      # retry requests with new authorization
      expect(a_request(:get, uri).with(headers: {"authorization" => "abc"}))
        .to have_been_made.times(retries_count)
    end
  end

  context "with 401 error on authorization call" do
    let(:retries_enabled) { true }
    let(:path) { PaypalAPI::Authentication::PATH }

    before do
      stub_request(:get, /#{PaypalAPI::Authentication::PATH}/o).to_return(status: 401)
    end

    it "returns error without retries" do
      expect { execute }.to raise_error PaypalAPI::Errors::Unauthorized
      expect(a_request(:get, /#{PaypalAPI::Authentication::PATH}/o)).to have_been_made.times(1)
    end
  end

  context "with configured callbacks" do
    let(:client) do
      client = PaypalAPI::Client.new(client_id: "x", client_secret: "x", retries: {enabled: false})
      client.add_callback(:before) { |req, ctx| double.call(:before, req, ctx) }
      client.add_callback(:after_success) { |req, ctx, resp| double.call(:after_success, req, ctx, resp) }
      client.add_callback(:after_fail) { |req, ctx, resp| double.call(:after_fail, req, ctx, resp) }
      client.add_callback(:after_network_error) { |req, ctx, err| double.call(:after_network_error, req, ctx, err) }
      PaypalAPI.client = client
    end

    let(:double) { proc {} }

    before { allow(double).to receive(:call) }

    after { PaypalAPI.client = nil }

    it "sends correct params to success callbacks" do
      stub_request(:get, uri).to_return(status: 200)
      execute

      expect(double).to have_received(:call)
        .with(:before, request, executer.callbacks_context).ordered

      expect(double).to have_received(:call)
        .with(:after_success, request, executer.callbacks_context, instance_of(PaypalAPI::Response)).ordered
    end

    it "sends correct params to fail request callback" do
      stub_request(:get, uri).to_return(status: 422)
      expect { execute }.to raise_error PaypalAPI::Errors::FailedRequest

      expect(double).to have_received(:call)
        .with(:before, request, executer.callbacks_context).ordered

      expect(double).to have_received(:call)
        .with(:after_fail, request, executer.callbacks_context, instance_of(PaypalAPI::Response)).ordered
    end

    it "sends correct params to callbacks when network error happens" do
      error = PaypalAPI::NetworkErrorBuilder::ERRORS.sample.allocate
      allow(Net::HTTP).to receive(:start).and_raise(error)

      expect { execute }.to raise_error PaypalAPI::Errors::NetworkError

      expect(double).to have_received(:call)
        .with(:before, request, executer.callbacks_context).ordered

      expect(double).to have_received(:call)
        .with(:after_network_error, request, executer.callbacks_context, error).ordered
    end
  end
end
