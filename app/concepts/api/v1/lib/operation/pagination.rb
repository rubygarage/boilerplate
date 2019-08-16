# frozen_string_literal: true

module Api::V1::Lib::Operation
  class Pagination < ApplicationOperation
    step Macro::Contract::Schema(Api::V1::Lib::Contract::PaginationValidation, name: :uri_query)
    step Contract::Validate(name: :uri_query), fail_fast: true
    step :pagy
    step :valid_page?
    fail Macro::AddContractError(name: :uri_query, page: [:number, [I18n.t('errors.pagination_overflow')]])

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
  end
end
