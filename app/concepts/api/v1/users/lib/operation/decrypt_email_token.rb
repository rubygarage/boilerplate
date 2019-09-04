# frozen_string_literal: true

module Api::V1::Users::Lib::Operation
  class DecryptEmailToken < ApplicationOperation
    step Macro::Contract::Schema(Api::V1::Users::Lib::Contract::DecryptEmailTokenValidation)
    step Contract::Validate(), fail_fast: true
    step Macro::Assign(to: :email_token, path: %w[contract.default email_token])
    step :set_payload
    fail Macro::AddContractError(base: 'errors.verification.invalid_email_token'), fail_fast: true
    step :set_model
    fail Macro::Semantic(failure: :not_found), fail_fast: true

    def set_payload(ctx, email_token:, **)
      ctx[:payload] = Api::V1::Users::Lib::Service::EmailToken.read(email_token)
    end

    def set_model(ctx, payload:, **)
      ctx[:model] = Account.find_by(id: payload[:account_id])
    end
  end
end
