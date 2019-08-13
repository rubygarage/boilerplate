# frozen_string_literal: true

module Api::V1::Users::Sessions::Contract
  Create = Dry::Validation.Schema do
    required(:email).filled(:str?)
    required(:password).filled(:str?)
  end
end
