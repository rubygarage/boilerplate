# frozen_string_literal: true

module Api::V1::Users::ResetPasswords::Operation
  class Update < ApplicationOperation
    step Macro::Inject.new.call(
      redis: 'adapters.redis',
      session: 'services.session_token',
      namespace: 'services.token_namespace',
      worker: Api::V1::Users::Lib::Worker::EmailNotification
    )
    step Subprocess(Api::V1::Users::Lib::Operation::DecryptEmailToken), fast_track: true
    step Subprocess(Api::V1::Users::Lib::Operation::CheckEmailTokenRedisEquality)
    step Contract::Build(constant: Api::V1::Users::ResetPasswords::Contract::Update)
    step Contract::Validate()
    step Contract::Persist()
    step :send_notification
    step :destroy_redis_email_token
    step :destroy_all_user_sessions

    def send_notification(_ctx, worker:, model:, **)
      worker.perform_async(email: model.email, user_mailer: :reset_password_successful)
    end

    def destroy_redis_email_token(_ctx, redis:, email_token:, **)
      redis.delete_token(email_token)
    end

    def destroy_all_user_sessions(_ctx, session:, namespace:, model:, **)
      session.destroy_all(
        namespace: namespace.call(Constants::TokenNamespace::SESSION, model.id)
      )
    end
  end
end
