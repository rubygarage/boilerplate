# frozen_string_literal: true

module Api::V1::Lib::Step
  class CreateUserTokens
    NAMESPACE_PREFIX = 'user-account-'

    def self.call(ctx, model:, **)
      id = model.id
      payload = { account_id: id }
      ctx[:tokens] = JWTSessions::Session.new(
        payload: payload,
        refresh_payload: payload,
        namespace: "#{Api::V1::Lib::Step::CreateUserTokens::NAMESPACE_PREFIX}#{id}"
      ).login
    end
  end
end
