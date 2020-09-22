# frozen_string_literal: true

module Api::V1::Users::Lib::Contract
  class DecryptEmailTokenValidation < Dry::Validation::Contract
    params do
      required(:email_token).filled(:string)
    end
  end
end
