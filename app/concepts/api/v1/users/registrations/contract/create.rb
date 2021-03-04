# frozen_string_literal: true

module Api::V1::Users::Registrations::Contract
  class Create < ApplicationContract
    property :email
    property :password
    property :password_confirmation, virtual: true

    validation do
      config.messages.namespace = :user_password

      option :form

      params do
        required(:email).filled(
          :str?,
          max_size?: Constants::Shared::EMAIL_MAX_LENGTH,
          format?: Constants::Shared::EMAIL_REGEX
        )
        required(:password).filled(:str?)
        required(:password_confirmation).filled(:str?)

        required(:password).filled(
          :str?,
          min_size?: Constants::Shared::PASSWORD_MIN_SIZE,
          format?: Constants::Shared::PASSWORD_REGEX
        )
      end

      rule(:password_confirmation) { key(:password_confirmation).failure(:match_passwords?) unless match_passwords? }

      rule(:email) { key(:email).failure(:email_uniq?) unless email_uniq? }

      def match_passwords?
        form.password == form.password_confirmation
      end

      def email_uniq?
        !Account.exists?(email: form.email)
      end
    end
  end
end
