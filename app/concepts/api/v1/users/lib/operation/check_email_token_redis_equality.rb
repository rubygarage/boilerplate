# frozen_string_literal: true

module Api::V1::Users::Lib::Operation
  class CheckEmailTokenRedisEquality < ApplicationOperation
    step Macro::Inject.new.call(redis: 'adapters.redis')
    step :tokens_eql?
    fail Macro::AddContractError.new.call(base: 'errors.email_token.already_used')

    def tokens_eql?(_ctx, redis:, email_token:, **)
      email_token.eql?(redis.find_token(email_token))
    end
  end
end
