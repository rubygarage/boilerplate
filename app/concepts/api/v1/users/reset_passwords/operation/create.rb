# frozen_string_literal: true

module Api::V1::Users::ResetPasswords::Operation
  class Create < ApplicationOperation
    step Macro::Contract::Schema(Api::V1::Users::ResetPasswords::Contract::Create)
    step Contract::Validate(), fail_fast: true
    step Model(Account, :find_by_email, :email)
    fail Macro::Semantic(failure: :not_found), fail_fast: true
    step :set_email_token
    step :push_email_token_to_redis
    step :send_reset_password_url
    step Macro::Semantic(success: :accepted)

    def set_email_token(ctx, model:, **)
      ctx[:email_token] = Api::V1::Users::Lib::Service::EmailToken.create(
        account_id: model.id, namespace: Constants::TokenNamespace::RESET_PASSWORD
      )
    end

    def push_email_token_to_redis(_ctx, email_token:, **)
      Api::V1::Users::Lib::Service::RedisAdapter.push_token(email_token)
    end

    def send_reset_password_url(_ctx, model:, email_token:, **)
      Api::V1::Users::ResetPasswords::Worker::EmailResetPasswordUrl.perform_async(
        email: model.email,
        token: email_token,
        user_reset_password_path: Rails.application.config.user_reset_password_path
      )
    end
  end
end
