# frozen_string_literal: true

module Api::V1::Users::Sessions::Contract
  class Create < Dry::Validation::Contract
    params do
      required(:email).filled(:str?)
      required(:password).filled(:str?)
    end
  end
end
