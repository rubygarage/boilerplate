# frozen_string_literal: true

module Api::V1::Users::Verifications::Operation
  class Show < ApplicationOperation
    step Macro::Contract::Schema(Api::V1::Users::Verifications::Contract::Show)
    step Contract::Validate(), fail_fast: true
    step Macro::Assign(to: :email_token, path: %w[contract.default email_token])
    step :set_payload
    fail Macro::AddContractError(base: 'errors.verification.invalid_email_token'), fail_fast: true
    step :set_model
    fail Macro::Semantic(failure: :not_found), fail_fast: true
    step :user_account_not_verified?
    fail Macro::AddContractError(base: 'errors.verification.user_account_already_verified'), fail_fast: true
    step :verify_user_account
    step :create_user
    step :send_notification

    def set_payload(ctx, email_token:, **)
      ctx[:payload] = Api::V1::Lib::Service::EmailToken.read(email_token)
    end

    def set_model(ctx, payload:, **)
      ctx[:model] = Account.find_by(id: payload[:account_id])
    end

    def user_account_not_verified?(_ctx, model:, **)
      !model.verified?
    end

    def verify_user_account(_ctx, model:, **)
      model.toggle!(:verified)
    end

    def create_user(_ctx, model:, **)
      model.create_user
    end

    def send_notification(_ctx, model:, **)
      Api::V1::Users::Verifications::Worker::EmailNotification.perform_async(email: model.email)
    end
  end
end
