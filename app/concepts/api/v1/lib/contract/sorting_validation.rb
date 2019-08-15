# frozen_string_literal: true

module Api::V1::Lib::Contract
  SortingValidation = Dry::Validation.Schema do
    configure do
      config.type_specs = true
      option :available_sortable_columns

      def sort_params_uniq?(jsonapi_sort_params)
        jsonapi_sort_params = jsonapi_sort_params.map(&:column)
        jsonapi_sort_params.eql?(jsonapi_sort_params.uniq)
      end

      def sort_params_valid?(jsonapi_sort_params)
        jsonapi_sort_params.all? do |jsonapi_sort_parameter|
          available_sortable_columns.include?(jsonapi_sort_parameter.column)
        end
      end
    end

    required(:sort, Types::JsonApi::Sort) { sort_params_uniq? & sort_params_valid? }
  end
end
