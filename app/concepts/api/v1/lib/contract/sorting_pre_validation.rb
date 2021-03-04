# frozen_string_literal: true

module Api::V1::Lib::Contract
  class SortingPreValidation < Dry::Validation::Contract
    params do
      required(:sort).filled(:str?)
    end
  end
end
