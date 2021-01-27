# frozen_string_literal: true

module Api::V1::Lib::Operation
  class PerformFiltering < ApplicationOperation
    step :filter_options_passed?, Output(:failure) => End(:success)
    pass :build_filter_query
    pass :filter_relation

    def filter_options_passed?(ctx, **)
      ctx[:filter_options]
    end

    def build_filter_query(ctx, filter_options:, **)
      ctx[:filter_query] = filter_options.map do |option|
        value = option[:value]
        value = value.split(',') if value.is_a?(String)
        value = value.first if value.is_a?(Array) && value.one?

        {
          "#{option[:column]}_#{option[:predicate]}": value
        }
      end.inject(:merge)
    end

    def filter_relation(ctx, filter_query:, relation:, **)
      ctx[:relation] = relation.ransack(filter_query).result
    end
  end
end
