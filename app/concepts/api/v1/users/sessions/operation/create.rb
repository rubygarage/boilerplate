# frozen_string_literal: true

module Api::V1::Users::Sessions::Operation
  class Create < ApplicationOperation
    step Macro::Contract::Schema(Api::V1::Users::Sessions::Contract::Create)
    step Contract::Validate(), fail_fast: true
    step Model(Account, :find_by_email, :email)
    fail Macro::Semantic(failure: :not_found)
    fail Macro::AddContractError(base: 'errors.session.not_found'), fail_fast: true
    step :authenticate
    fail Macro::Semantic(failure: :unauthorized)
    fail Macro::AddContractError(base: 'errors.session.wrong_credentials'), fail_fast: true
    step :set_user_tokens
    step Macro::Semantic(success: :created)
    step Macro::Renderer(serializer: Api::V1::Lib::Serializer::Account, meta: :tokens)

    def authenticate(ctx, model:, **)
      model.authenticate(ctx['contract.default'].password)
    end

    def set_user_tokens(ctx, model:, **)
      ctx[:tokens] = Api::V1::Users::Lib::Service::SessionToken::Create.call(
        account_id: model.id, namespace: Constants::TokenNamespace::SESSION
      )
    end
  end
end
