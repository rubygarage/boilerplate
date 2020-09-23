# frozen_string_literal: true

module Api::V1::Lib::Contract
  class SortingValidation < Dry::Validation::Contract
    option :available_sortable_columns

    params do
      required(:sort).value(Types::JsonApi::Sort)
    end

    rule(:sort).validate(:sort_params_uniq?)
    rule(:sort).validate(:sort_params_valid?)

    Dry::Validation.register_macro(:sort_params_uniq?) do
      jsonapi_sort_params = value.map(&:column)
      key.failure(:sort_params_uniq?) unless jsonapi_sort_params.eql?(jsonapi_sort_params.uniq)
    end

    Dry::Validation.register_macro(:sort_params_valid?) do
      value.all? do |jsonapi_sort_parameter|
        key.failure(:sort_params_valid?) unless available_sortable_columns.include?(jsonapi_sort_parameter.column)
      end
    end
  end
end
