# frozen_string_literal: true

module Api::V1::Users::Sessions::Operation
  class Destroy < ApplicationOperation
    step Rescue(JWTSessions::Errors::Unauthorized) {
      step :destroy_user_session
    }
    step Macro::Semantic(success: :destroyed)

    def destroy_user_session(_ctx, found_token:, **)
      Api::V1::Users::Lib::Service::SessionToken::Destroy.call(refresh_token: found_token)
    end
  end
end
