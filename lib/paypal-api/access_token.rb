# frozen_string_literal: true

module PaypalAPI
  #
  # AccessToken object stores authorization string and its expire time.
  #
  class AccessToken
    attr_reader :requested_at, :expires_at, :authorization_string

    def initialize(requested_at:, expires_in:, access_token:, token_type:)
      @requested_at = requested_at
      @expires_at = requested_at + expires_in
      @authorization_string = "#{token_type} #{access_token}"
      freeze
    end

    def expired?
      Time.now >= expires_at
    end

    def inspect
      "#<#{self.class.name} methods: (requested_at, expires_at, expired?, authorization_string)>"
    end

    alias_method :to_s, :inspect
  end
end
