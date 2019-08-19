# frozen_string_literal: true

module Helpers
  module RootHelpers
    def create_token(type, access_token = :unexpired, account: nil)
      allow(JWTSessions).to receive(:access_exp_time).and_return(0) if access_token.eql?(:expired)
      JWTSessions::Session.new(
        access_claims: { exp: Time.now.to_i },
        payload: { account_id: account&.id || rand(1..42) }
      ).login[type]
    end
  end
end
