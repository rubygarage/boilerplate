# frozen_string_literal: true

module Api::V1::Lib::Operation
  class PerformOrdering < ApplicationOperation
    step :order_options_passed?, Output(:failure) => End(:success)
    pass :order_relation

    def order_options_passed?(ctx, **)
      ctx[:order_options]
    end

    def order_relation(ctx, order_options:, relation:, **)
      ctx[:relation] = relation.reorder(order_options)
    end
  end
end
