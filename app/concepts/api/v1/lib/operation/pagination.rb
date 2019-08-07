# frozen_string_literal: true

module Api::V1::Lib::Operation
  class Pagination < ApplicationOperation
    step Macro::Contract::Schema(Api::V1::Lib::Contract::PaginationValidation, name: :uri_query)
    step Contract::Validate(name: :uri_query), fail_fast: true
    step :pagy
    step :valid_page?
    fail :overflow

    def pagy(ctx, model:, **)
      ctx[:pagy], ctx[:model] =
        Service::Pagy.call(
          model,
          page: ctx['contract.uri_query'].page.try(:number),
          items: ctx['contract.uri_query'].page.try(:size)
        )
    end

    def valid_page?(_ctx, pagy:, **)
      !pagy.overflow?
    end

    def overflow(ctx, **)
      ctx['contract.uri_query'].errors.add(:page, [:number, [I18n.t('errors.pagination_overflow')]])
    end
  end
end
