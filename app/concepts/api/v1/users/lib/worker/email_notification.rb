# frozen_string_literal: true

module Api::V1::Users::Lib::Worker
  class EmailNotification < ApplicationWorker
    def perform(email:, user_mailer:)
      UserMailer.public_send(user_mailer, email).deliver_now
    end
  end
end
