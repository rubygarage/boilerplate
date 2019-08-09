# frozen_string_literal: true

module Api::V1::Lib::Contract
  SortingPreValidation = Dry::Validation.Schema do
    required(:sort).filled(:str?)
  end
end
