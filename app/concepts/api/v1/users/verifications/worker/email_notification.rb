# frozen_string_literal: true

module Api::V1::Users::Verifications::Worker
  class EmailNotification < ApplicationWorker
    def perform(email:)
      UserMailer.notification(email).deliver_now
    end
  end
end
