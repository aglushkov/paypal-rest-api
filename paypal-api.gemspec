# frozen_string_literal: true

require_relative "lib/paypal-api/version"

Gem::Specification.new do |spec|
  spec.name = "paypal-api"
  spec.version = PaypalAPI::VERSION
  spec.authors = ["Andrey Glushkov"]
  spec.email = ["aglushkov@shakuro.com"]

  spec.summary = "PayPal REST API"
  spec.description = "PayPal REST API with no dependencies."
  spec.homepage = "https://github.com/aglushkov/paypal-api"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/serega"
  spec.metadata["changelog_uri"] = spec.homepage + "/blob/master/CHANGELOG.md"

  spec.files = Dir["lib/**/*.rb"] << "VERSION" << "README.md"
  spec.require_paths = ["lib"]
end
