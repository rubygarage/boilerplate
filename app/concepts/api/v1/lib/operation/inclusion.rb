# frozen_string_literal: true

module Api::V1::Lib::Operation
  class Inclusion < ApplicationOperation
    step :inclusion_query_param_passed?, Output(:failure) => End(:success)
    step Macro::Contract::Schema(
      Api::V1::Lib::Contract::InclusionValidation,
      name: :uri_query,
      inject: %i[available_inclusion_options]
    )
    step Contract::Validate(name: :uri_query)
    step Macro::Assign(to: :inclusion_options, path: %w[contract.uri_query include])

    def inclusion_query_param_passed?(_ctx, params:, **)
      params[:include]
    end
  end
end
