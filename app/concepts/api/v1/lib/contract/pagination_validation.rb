# frozen_string_literal: true

module Api::V1::Lib::Contract
  class PaginationValidation < Dry::Validation::Contract
    params do
      optional(:page).maybe(:hash?) do
        schema do
          optional(:number).maybe(:int?, gteq?: JsonApi::Pagination::MINIMAL_VALUE)
          optional(:size).maybe(:int?, gteq?: JsonApi::Pagination::MINIMAL_VALUE)
        end
      end
    end
  end
end
