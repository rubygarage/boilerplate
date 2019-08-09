# frozen_string_literal: true

module Api::V1::Lib::Contract
  FilteringPreValidation = Dry::Validation.Schema do
    required(:filter).filled(:hash?)
    optional(:match).filled(:str?, included_in?: JsonApi::Filtering::OPERATORS)
  end
end
