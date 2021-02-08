# frozen_string_literal: true

module Api::V1::Users
  class VerificationsController < ApiController
    def show
      endpoint operation: Api::V1::Users::Verifications::Operation::Show
    end
  end
end
