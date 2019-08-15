# frozen_string_literal: true

module Api::V1::Lib::Operation
  class Sorting < ApplicationOperation
    step :sort_params_passed?, Output(:failure) => End(:success)
    step Macro::Contract::Schema(Api::V1::Lib::Contract::SortingPreValidation, name: :uri_query)
    step Contract::Validate(name: :uri_query)
    step :set_validation_dependencies
    step Macro::Contract::Schema(
      Api::V1::Lib::Contract::SortingValidation,
      inject: %i[available_sortable_columns],
      name: :uri_query
    )
    step Contract::Validate(name: :uri_query), id: :sorting_validation
    step :order_options

    def sort_params_passed?(_ctx, params:, **)
      params[:sort]
    end

    def set_validation_dependencies(ctx, available_columns:, **)
      ctx[:available_sortable_columns] = available_columns.select(&:sortable).map(&:name).to_set
    end

    def order_options(ctx, **)
      ctx[:order_options] = ctx['contract.uri_query'].sort.map do |jsonapi_sort_parameter|
        { jsonapi_sort_parameter.column.to_sym => jsonapi_sort_parameter.order.to_sym }
      end
    end
  end
end
