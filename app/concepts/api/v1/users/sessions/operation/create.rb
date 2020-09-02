# frozen_string_literal: true

module Api::V1::Users::Sessions::Operation
  class Create < ApplicationOperation
    step Macro::Inject.new.call(session: 'services.session_token')
    step Macro::Contract::Schema(Api::V1::Users::Sessions::Contract::Create)
    step Contract::Validate(), fail_fast: true
    step Model(Account, :find_by_email, :email)
    fail Macro::Semantic.new.call(failure: :not_found)
    fail Macro::AddContractError.new.call(base: 'errors.session.not_found'), fail_fast: true
    step :authenticate
    fail Macro::Semantic.new.call(failure: :unauthorized)
    fail Macro::AddContractError.new.call(base: 'errors.session.wrong_credentials')
    step :set_user_tokens
    step Macro::Semantic.new.call(success: :created)
    step Macro::Renderer.new.call(serializer: Api::V1::Lib::Serializer::Account, meta: :tokens)

    def authenticate(ctx, model:, **)
      model.authenticate(ctx['contract.default'].password)
    end

    def set_user_tokens(ctx, session:, model:, **)
      ctx[:tokens] = session.create(account_id: model.id, namespace: Constants::TokenNamespace::SESSION)
    end
  end
end
