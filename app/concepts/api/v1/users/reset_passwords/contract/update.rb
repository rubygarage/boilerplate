# frozen_string_literal: true

module Api::V1::Users::ResetPasswords::Contract
  class Update < ApplicationContract
    property :password
    property :password_confirmation, virtual: true

    validation do
      configure { config.namespace = :user_password }

      required(:password).filled(:str?)
      required(:password_confirmation).filled(:str?)

      required(:password).filled(
        :str?,
        min_size?: Constants::Shared::PASSWORD_MIN_SIZE,
        format?: Constants::Shared::PASSWORD_REGEX
      ).confirmation
    end
  end
end
