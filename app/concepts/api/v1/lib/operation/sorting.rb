# frozen_string_literal: true

module Api::V1::Lib::Operation
  class Sorting < ApplicationOperation
    step :sort_params_passed?, Output(:failure) => End(:success)
    step Macro::Contract::Schema(Api::V1::Lib::Contract::SortingPreValidation, name: :uri_query)
    step Contract::Validate(name: :uri_query)
    step Macro::Contract::Schema(
      Api::V1::Lib::Contract::SortingValidation,
      inject: %i[available_columns],
      name: :uri_query
    )
    step Contract::Validate(name: :uri_query), id: :sorting_validation
    step :order_options

    def sort_params_passed?(_ctx, params:, **)
      params[:sort]
    end

    def order_options(ctx, **)
      ctx[:order_options] = ctx['contract.uri_query'].sort.map do |jsonapi_sort_parameter|
        order_type, attribute =
          jsonapi_sort_parameter.scan(JsonApi::Sorting::JSONAPI_SORT_PATTERN).flatten

        { attribute.to_sym => order_type ? :desc : :asc }
      end
    end
  end
end
