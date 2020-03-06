# frozen_string_literal: true

module Api::V1::Users::Sessions::Operation
  class Destroy < ApplicationOperation
    step Macro::Inject(session: 'services.session_token')
    step Rescue(JWTSessions::Errors::Unauthorized) {
      step :destroy_user_session
    }
    step Macro::Semantic(success: :destroyed)

    def destroy_user_session(_ctx, session:, found_token:, **)
      session.destroy(refresh_token: found_token)
    end
  end
end
