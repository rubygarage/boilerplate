# frozen_string_literal: true

module Api::V1::Users
  class SessionsController < ApiController
    def create
      endpoint operation: Api::V1::Users::Sessions::Operation::Create
    end

    def destroy
      authorize_refresh_request!
      endpoint operation: Api::V1::Users::Sessions::Operation::Destroy, options: { found_token: found_token }
    end
  end
end
