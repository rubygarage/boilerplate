# frozen_string_literal: true

module Api::V1::Users::ResetPasswords::Operation
  class Create < ApplicationOperation
    step Macro::Inject(
      jwt: 'services.email_token',
      redis: 'adapters.redis',
      worker: Api::V1::Users::ResetPasswords::Worker::EmailResetPasswordUrl
    )
    step Macro::Contract::Schema(Api::V1::Users::ResetPasswords::Contract::Create)
    step Contract::Validate(), fail_fast: true
    step Model(Account, :find_by_email, :email)
    fail Macro::Semantic(failure: :not_found)
    fail Macro::AddContractError(email: 'errors.reset_password.email_not_found'), fail_fast: true
    step :set_email_token
    step :push_email_token_to_redis
    step :send_reset_password_url
    step Macro::Semantic(success: :accepted)

    def set_email_token(ctx, jwt:, model:, **)
      ctx[:email_token] = jwt.create(account_id: model.id, namespace: Constants::TokenNamespace::RESET_PASSWORD)
    end

    def push_email_token_to_redis(_ctx, redis:, email_token:, **)
      redis.push_token(email_token)
    end

    def send_reset_password_url(_ctx, worker:, model:, email_token:, **)
      worker.perform_async(
        email: model.email,
        token: email_token,
        user_reset_password_path: Rails.application.config.user_reset_password_path
      )
    end
  end
end
