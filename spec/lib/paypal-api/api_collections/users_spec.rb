# frozen_string_literal: true

RSpec.describe PaypalAPI::Users do
  it_behaves_like "endpoint",
    api_method: :create,
    http_method: :post,
    path: "/v2/scim/Users"

  it_behaves_like "endpoint",
    api_method: :list,
    http_method: :get,
    path: "/v2/scim/Users"

  it_behaves_like "endpoint",
    api_method: :show,
    http_method: :get,
    path: "/v2/scim/Users/%<user_id>s",
    path_args: {user_id: "123"}

  it_behaves_like "endpoint",
    api_method: :update,
    http_method: :patch,
    path: "/v2/scim/Users/%<user_id>s",
    path_args: {user_id: "123"}

  it_behaves_like "endpoint",
    api_method: :delete,
    http_method: :delete,
    path: "/v2/scim/Users/%<user_id>s",
    path_args: {user_id: "123"}

  it "add SCIM JSON content-type" do
    client = instance_double(PaypalAPI::Client, post: "RESPONSE")
    resource = described_class.new(client)
    resource.create

    expect(client).to have_received(:post) do |_path, **kwargs|
      expect(kwargs[:headers]["content-type"]).to eq "application/scim+json"
    end
  end

  it "does not changes content-type header" do
    client = instance_double(PaypalAPI::Client, post: "RESPONSE")
    resource = described_class.new(client)
    resource.create(headers: {"Content-Type" => "foo"})

    expect(client).to have_received(:post) do |_path, **kwargs|
      expect(kwargs[:headers]["content-type"]).to eq "foo"
    end
  end
end
