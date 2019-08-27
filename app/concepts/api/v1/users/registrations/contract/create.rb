# frozen_string_literal: true

module Api::V1::Users::Registrations::Contract
  class Create < ApplicationContract
    property :email
    property :password
    property :password_confirmation, virtual: true

    validation :default do
      configure { config.namespace = :user_password }

      required(:email).filled(
        :str?,
        max_size?:
        Constants::Shared::EMAIL_MAX_LENGTH,
        format?: Constants::Shared::EMAIL_REGEX
      )
      required(:password).filled(:str?)
      required(:password_confirmation).filled(:str?)

      required(:password).filled(
        :str?,
        min_size?: Constants::Shared::PASSWORD_MIN_SIZE,
        format?: Constants::Shared::PASSWORD_REGEX
      ).confirmation
    end

    validation :email, if: :default do
      configure do
        def email_uniq?(value)
          !Account.exists?(email: value)
        end
      end

      required(:email, &:email_uniq?)
    end
  end
end
