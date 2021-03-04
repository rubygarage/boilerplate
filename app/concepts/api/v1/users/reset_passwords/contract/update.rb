# frozen_string_literal: true

module Api::V1::Users::ResetPasswords::Contract
  class Update < ApplicationContract
    property :password
    property :password_confirmation, virtual: true

    validation do
      config.messages.namespace = :user_password

      option :form

      params do
        required(:password).filled(:str?)
        optional(:password_confirmation).maybe(:string)

        required(:password).filled(
          :str?,
          min_size?: Constants::Shared::PASSWORD_MIN_SIZE,
          format?: Constants::Shared::PASSWORD_REGEX
        )
      end

      rule(:password_confirmation) { key(:password_confirmation).failure(:match_passwords?) unless match_passwords? }

      def match_passwords?
        form.password == form.password_confirmation
      end
    end
  end
end
