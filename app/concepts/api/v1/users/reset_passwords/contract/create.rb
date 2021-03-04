# frozen_string_literal: true

module Api::V1::Users::ResetPasswords::Contract
  class Create < Dry::Validation::Contract
    params do
      required(:email).filled(
        :str?,
        max_size?: Constants::Shared::EMAIL_MAX_LENGTH,
        format?: Constants::Shared::EMAIL_REGEX
      )
    end
  end
end
