# frozen_string_literal: true

module Api::V1::Users::Sessions::Refreshes::Operation
  class Create < ApplicationOperation
    step Macro::Inject.new.call(session: 'services.session_token')
    step Rescue(JWTSessions::Errors::Unauthorized) {
      step :refresh_user_tokens
    }
    fail Macro::Semantic.new.call(failure: :forbidden)
    step Macro::Semantic.new.call(success: :created)
    step Macro::Renderer.new.call(meta: :tokens)

    def refresh_user_tokens(ctx, session:, payload:, found_token:, **)
      ctx[:tokens] = session.refresh(payload: payload, refresh_token: found_token)
    end
  end
end
