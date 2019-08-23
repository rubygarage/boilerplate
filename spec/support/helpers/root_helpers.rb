# frozen_string_literal: true

module Helpers
  module RootHelpers
    def create_token(type, account: nil)
      JWTSessions::Session.new(
        payload: { account_id: account&.id || rand(1..42) }
      ).login[type]
    end
  end
end
