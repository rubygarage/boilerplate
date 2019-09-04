# frozen_string_literal: true

module Api::V1::Users::Sessions::Refreshes::Operation
  class Create < ApplicationOperation
    step Rescue(JWTSessions::Errors::Unauthorized) {
      step :refresh_user_tokens
    }
    fail Macro::Semantic(failure: :forbidden)
    step Macro::Semantic(success: :created)
    step Macro::Renderer(meta: :tokens)

    def refresh_user_tokens(ctx, payload:, found_token:, **)
      ctx[:tokens] = Api::V1::Users::Lib::Service::SessionToken::Refresh.call(
        payload: payload, refresh_token: found_token
      )
    end
  end
end
