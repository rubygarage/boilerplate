# frozen_string_literal: true

module Api::V1::Users::Registrations::Operation
  class Create < ApplicationOperation
    step Macro::Inject(jwt: 'services.email_token', worker: Api::V1::Users::Registrations::Worker::EmailConfirmation)
    step Model(Account, :new)
    step Contract::Build(constant: Api::V1::Users::Registrations::Contract::Create, name: 'registration')
    step Contract::Validate(name: 'registration')
    step Contract::Persist(name: 'registration')
    fail Macro::Semantic(failure: :bad_request)
    step :set_email_token
    step :send_confirmation_link
    step Macro::Renderer(serializer: Api::V1::Lib::Serializer::Account)
    pass Macro::Semantic(success: :created)

    def set_email_token(ctx, jwt:, model:, **)
      ctx[:email_token] = jwt.create(account_id: model.id)
    end

    def send_confirmation_link(_ctx, worker:, model:, email_token:, **)
      worker.perform_async(
        email: model.email,
        token: email_token,
        user_verification_path: Rails.application.config.user_verification_path
      )
    end
  end
end
