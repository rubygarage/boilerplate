# frozen_string_literal: true

module Api::V1::Lib::Contract
  class FilteringPreValidation < Dry::Validation::Contract
    params do
      required(:filter).filled(:hash?)
      optional(:match).filled(:str?, included_in?: JsonApi::Filtering::OPERATORS)
    end
  end
end
