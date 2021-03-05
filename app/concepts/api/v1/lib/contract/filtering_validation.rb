# frozen_string_literal: true

module Api::V1::Lib::Contract
  class FilteringValidation < Dry::Validation::Contract
    option :available_filtering_columns
    option :column_type_dict

    params do
      required(:filter).filled(Types::JsonApi::Filter)
    end

    rule(:filter).validate(:filters_uniq?)

    rule(:filter).each do |index:|
      key([:filter, index]).failure(:filtering_column_valid?) and next unless valid_column?(value)
      key([:filter, index]).failure(:filtering_predicate_valid?) and next unless predicate_column?(value)

      key([:filter, index]).failure(:filtering_value_valid?) unless valid_value?(value)
    end

    def valid_value?(value)
      Types::JsonApi::TypeByColumn.call(column_type_dict[value.column]).try(value.value)&.success?
    end

    def predicate_column?(value)
      JsonApi::Filtering::PREDICATES[column_type_dict[value.column]]&.include?(value.predicate)
    end

    def valid_column?(value)
      available_filtering_columns.include?(value.column)
    end

    Dry::Validation.register_macro(:filters_uniq?) do
      filters = value.map(&:column)
      key.failure(:filters_uniq?) unless filters.eql?(filters.uniq)
    end
  end
end
