# frozen_string_literal: true

module Api::V1::Users::Session
  class RefreshesController < ApiController
    def create
      authorize_refresh_request!
      endpoint Api::V1::Users::Sessions::Refreshes::Operation::Create,
               options: { found_token: found_token, payload: payload }
    end
  end
end
