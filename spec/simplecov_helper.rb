# frozen_string_literal: true

if RUBY_ENGINE == "ruby" && RUBY_VERSION.start_with?("3.3.") && (ARGV.none? || ARGV == ["spec"] || ARGV == ["spec/"])
  begin
    require "simplecov"

    SimpleCov.start do
      enable_coverage :branch
      minimum_coverage line: 100, branch: 100
    end
  rescue LoadError
  end
end
