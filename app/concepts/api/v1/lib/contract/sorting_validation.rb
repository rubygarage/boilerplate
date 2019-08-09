# frozen_string_literal: true

module Api::V1::Lib::Contract
  SortingValidation = Dry::Validation.Schema do
    configure do
      config.type_specs = true
      option :available_columns

      def sort_params_uniq?(jsonapi_sort_params)
        jsonapi_sort_params = jsonapi_sort_params.map do |jsonapi_sort_parameter|
          jsonapi_sort_parameter[JsonApi::Sorting::JSONAPI_SORT_PATTERN, 2]
        end
        jsonapi_sort_params == jsonapi_sort_params.uniq
      end

      def sort_params_valid?(jsonapi_sort_params)
        available_sortable_columns = available_columns.map do |available_column|
          available_column[:name] if available_column[:sortable]
        end.compact

        jsonapi_sort_params.all? do |jsonapi_sort_parameter|
          available_sortable_columns.include?(
            jsonapi_sort_parameter[JsonApi::Sorting::JSONAPI_SORT_PATTERN, 2]
          )
        end
      end
    end

    required(:sort, Types::JsonApi::Sort) { sort_params_uniq? & sort_params_valid? }
  end
end
