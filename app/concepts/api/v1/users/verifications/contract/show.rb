# frozen_string_literal: true

module Api::V1::Users::Verifications::Contract
  Show = Dry::Validation.Schema do
    required(:email_token).filled(:str?)
  end
end
