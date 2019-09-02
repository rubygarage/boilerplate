# frozen_string_literal: true

module Api::V1::Users::Registrations::Worker
  class EmailConfirmation < ApplicationWorker
    def perform(email:, token:, user_verification_path:)
      UserMailer.confirmation(email, token, user_verification_path).deliver_now
    end
  end
end
