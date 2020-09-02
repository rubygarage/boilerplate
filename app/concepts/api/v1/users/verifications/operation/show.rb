# frozen_string_literal: true

module Api::V1::Users::Verifications::Operation
  class Show < ApplicationOperation
    step Macro::Inject.new.call(worker: Api::V1::Users::Lib::Worker::EmailNotification)
    step Subprocess(Api::V1::Users::Lib::Operation::DecryptEmailToken), fast_track: true
    step :user_account_not_verified?
    fail Macro::AddContractError.new.call(base: 'errors.verification.user_account_already_verified')
    step :verify_user_account
    step :create_user
    step :send_notification

    def user_account_not_verified?(_ctx, model:, **)
      !model.verified?
    end

    def verify_user_account(_ctx, model:, **)
      model.toggle!(:verified)
    end

    def create_user(_ctx, model:, **)
      model.create_user
    end

    def send_notification(_ctx, worker:, model:, **)
      worker.perform_async(email: model.email, user_mailer: :verification_successful)
    end
  end
end
