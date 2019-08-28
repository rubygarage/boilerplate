# frozen_string_literal: true

module Api::V1::Users::ResetPasswords::Worker
  class EmailResetPasswordUrl < ApplicationWorker
    def perform(email:, token:, user_reset_password_path:)
      UserMailer.reset_password(email, token, user_reset_password_path).deliver_now
    end
  end
end
