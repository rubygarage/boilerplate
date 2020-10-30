# frozen_string_literal: true

module Api::V1::Users::Sessions::Operation
  class Create < ApplicationOperation
    step Macro::Inject(session: 'services.session_token')
    step Macro::Contract::Schema(Api::V1::Users::Sessions::Contract::Create)
    step Contract::Validate(), fail_fast: true
    step Model(Account, :find_by_email, :email)
    step :authenticate
    fail Macro::Semantic(failure: :unauthorized)
    fail Macro::AddContractError(base: 'errors.session.wrong_credentials'), fail_fast: true
    step :set_user_tokens
    step Macro::Semantic(success: :created)
    step Macro::Renderer(serializer: Api::V1::Lib::Serializer::Account, meta: :tokens)

    def authenticate(ctx, model:, **)
      model.authenticate(ctx['contract.default'].password)
    end

    def set_user_tokens(ctx, session:, model:, **)
      ctx[:tokens] = session.create(account_id: model.id, namespace: Constants::TokenNamespace::SESSION)
    end
  end
end
