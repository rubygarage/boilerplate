# frozen_string_literal: true

module Api::V1::Users::Sessions::Service::Tokens
  module Create
    def self.call(account_id:)
      JWTSessions::Session.new(payload: { account_id: account_id }).login
    end
  end

  module Destroy
    def self.call(token:)
      JWTSessions::Session.new.flush_by_token(token)
    end
  end
end
