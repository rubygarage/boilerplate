# frozen_string_literal: true

module Api::V1::Users::Lib::Operation
  class CheckEmailTokenRedisEquality < ApplicationOperation
    step :tokens_eql?
    fail Macro::AddContractError(base: 'errors.email_token.already_used')

    def tokens_eql?(_ctx, email_token:, **)
      email_token.eql?(Api::V1::Users::Lib::Service::RedisAdapter.find_token(email_token))
    end
  end
end
