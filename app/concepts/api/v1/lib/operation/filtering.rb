# frozen_string_literal: true

module Api::V1::Lib::Operation
  class Filtering < ApplicationOperation
    step :filter_params_passed?, Output(:failure) => End(:success)
    step Macro::Contract::Schema(Api::V1::Lib::Contract::FilteringPreValidation, name: :uri_query)
    step Contract::Validate(name: :uri_query)
    step :matcher_options
    step :set_validation_dependencies
    step Macro::Contract::Schema(
      Api::V1::Lib::Contract::FilteringValidation,
      inject: %i[available_filtering_columns column_type_dict],
      name: :uri_query
    )
    step Contract::Validate(name: :uri_query), id: :filtering_validation
    step :filter_options

    def filter_params_passed?(_ctx, params:, **)
      params[:filter]
    end

    def matcher_options(ctx, **)
      ctx[:matcher_options] = ctx['contract.uri_query'].match || JsonApi::Filtering::Operators::MATCH_ALL
    end

    def set_validation_dependencies(ctx, available_columns:, **)
      ctx[:available_filtering_columns] = available_columns.select(&:filterable).map(&:name).to_set
      ctx[:column_type_dict] = available_columns.map { |column| [column.name, column.type] }.to_h
    end

    def filter_options(ctx, **)
      ctx[:filter_options] = ctx['contract.uri_query'].filter.map(&:to_h)
    end
  end
end
