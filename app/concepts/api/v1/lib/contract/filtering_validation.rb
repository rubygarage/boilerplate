# frozen_string_literal: true

module Api::V1::Lib::Contract
  class FilteringValidation < Dry::Validation::Contract
    option :available_filtering_columns
    option :column_type_dict

    params do
      required(:filter).filled(Types::JsonApi::Filter)
    end

    rule(:filter).validate(:filters_uniq?)

    rule(:filter).each do
      key.failure(:filtering_column_valid?) unless available_filtering_columns.include?(value.column)
      unless JsonApi::Filtering::PREDICATES[column_type_dict[value.column]].include?(value.predicate)
        key.failure(:filtering_predicate_valid?)
      end
      unless Types::JsonApi::TypeByColumn.call(column_type_dict[value.column]).try(value.value).success?
        key.failure(:filtering_value_valid?)
      end
    end

    Dry::Validation.register_macro(:filters_uniq?) do
      filters = value.map(&:column)
      filters.eql?(filters.uniq)
    end
  end
end
