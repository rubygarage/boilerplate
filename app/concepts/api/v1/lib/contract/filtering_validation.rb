# frozen_string_literal: true

module Api::V1::Lib::Contract
  FilteringValidation = Dry::Validation.Schema do
    configure do
      config.type_specs = true
      option :available_filtering_columns
      option :column_type_dict

      def filtering_column_valid?(filter)
        available_filtering_columns.include?(filter.column)
      end

      def filtering_predicate_valid?(filter)
        column = column_type_dict[filter.column]
        JsonApi::Filtering::PREDICATES[column].include?(filter.predicate)
      end

      def filtering_value_valid?(filter)
        column = column_type_dict[filter.column]
        Types::JsonApi::TypeByColumn.call(column).try(filter.value).success?
      end

      def filters_uniq?(filters)
        filters = filters.map(&:column)
        filters.eql?(filters.uniq)
      end
    end

    required(:filter, Types::JsonApi::Filter).filled(:array?, :filters_uniq?) do
      each(:filtering_column_valid?, :filtering_predicate_valid?, :filtering_value_valid?)
    end
  end
end
