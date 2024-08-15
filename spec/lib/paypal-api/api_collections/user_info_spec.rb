# frozen_string_literal: true

RSpec.describe PaypalAPI::UserInfo do
  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v1/identity/openidconnect/userinfo"

  it "add `openid` schema query param by default" do
    client = instance_double(PaypalAPI::Client, get: "RESPONSE")
    resource = described_class.new(client)
    resource.show

    expect(client).to have_received(:get) do |_path, **kwargs|
      expect(kwargs[:query][:schema]).to eq "openid"
    end
  end

  it "does not change schema param" do
    client = instance_double(PaypalAPI::Client, get: "RESPONSE")
    resource = described_class.new(client)
    resource.show(query: {"schema" => "foo"})

    expect(client).to have_received(:get) do |_path, **kwargs|
      expect(kwargs[:query]).to eq({"schema" => "foo"})
    end
  end
end
