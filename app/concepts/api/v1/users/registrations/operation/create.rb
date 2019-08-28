# frozen_string_literal: true

module Api::V1::Users::Registrations::Operation
  class Create < ApplicationOperation
    step Model(Account, :new)
    step Contract::Build(constant: Api::V1::Users::Registrations::Contract::Create)
    step Contract::Validate()
    step Contract::Persist()
    step Macro::Semantic(success: :created)
    step :set_email_token
    step :send_confirmation_link
    step Macro::Renderer(serializer: Api::V1::Lib::Serializer::Account)

    def set_email_token(ctx, model:, **)
      ctx[:email_token] = Api::V1::Users::Lib::Service::EmailToken.create(account_id: model.id)
    end

    def send_confirmation_link(_ctx, model:, email_token:, **)
      Api::V1::Users::Registrations::Worker::EmailConfirmation.perform_async(
        email: model.email,
        token: email_token,
        user_verification_path: Rails.application.config.user_verification_path
      )
    end
  end
end
