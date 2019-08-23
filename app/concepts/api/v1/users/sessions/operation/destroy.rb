# frozen_string_literal: true

module Api::V1::Users::Sessions::Operation
  class Destroy < ApplicationOperation
    step Rescue(JWTSessions::Errors::Unauthorized) {
      step :clear_user_session
    }
    step Macro::Semantic(success: :destroyed)

    def clear_user_session(_ctx, found_token:, **)
      Api::V1::Users::Sessions::Service::Tokens::Destroy.call(token: found_token)
    end
  end
end
