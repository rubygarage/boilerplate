# frozen_string_literal: true

module Api::V1::Users::ResetPasswords::Contract
  Create = Dry::Validation.Schema do
    required(:email).filled(
      :str?,
      max_size?: Constants::Shared::EMAIL_MAX_LENGTH,
      format?: Constants::Shared::EMAIL_REGEX
    )
  end
end
