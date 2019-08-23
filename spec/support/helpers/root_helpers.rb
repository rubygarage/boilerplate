# frozen_string_literal: true

module Helpers
  module RootHelpers
    # :reek:TooManyStatements
    def create_token(type, access_token = :unexpired, account: nil) # rubocop:disable Metrics/AbcSize
      payload, current_time = { account_id: account&.id || rand(1..42) }, Time.now.to_i

      time =
        if access_token.eql?(:expired)
          allow(JWTSessions).to receive(:access_exp_time).and_return(0)
          current_time - 10
        else
          24.hours.from_now.to_i
        end

      return JWT.encode(payload.merge(exp: time), Constants::Shared::HMAC_SECRET) if type.eql?(:email)

      JWTSessions::Session.new(
        access_claims: { exp: current_time },
        payload: payload
      ).login[type]
    end
  end
end
