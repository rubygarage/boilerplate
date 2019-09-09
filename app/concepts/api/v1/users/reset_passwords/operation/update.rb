# frozen_string_literal: true

module Api::V1::Users::ResetPasswords::Operation
  class Update < ApplicationOperation
    step Subprocess(Api::V1::Users::Lib::Operation::DecryptEmailToken), fast_track: true
    step Subprocess(Api::V1::Users::Lib::Operation::CheckEmailTokenRedisEquality), fast_track: true
    step Contract::Build(constant: Api::V1::Users::ResetPasswords::Contract::Update)
    step Contract::Validate()
    step Contract::Persist()
    step :send_notification
    step :destroy_redis_email_token
    step :destroy_all_user_sessions

    def send_notification(_ctx, model:, **)
      Api::V1::Users::Lib::Worker::EmailNotification.perform_async(
        email: model.email, user_mailer: :reset_password_successful
      )
    end

    def destroy_redis_email_token(_ctx, email_token:, **)
      Api::V1::Users::Lib::Service::RedisAdapter.delete_token(email_token)
    end

    def destroy_all_user_sessions(_ctx, model:, **)
      Api::V1::Users::Lib::Service::SessionToken::DestroyAll.call(
        namespace: Api::V1::Users::Lib::Service::TokenNamespace.call(
          Constants::TokenNamespace::SESSION, model.id
        )
      )
    end
  end
end
