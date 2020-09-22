# frozen_string_literal: true

module Api::V1::Lib::Contract
  class InclusionValidation < ApplicationContract
    option :available_inclusion_options

    params do
      required(:include).value(Types::JsonApi::Include)
    end

    rule(:include).validate(:invalid_inclusion_params?, :unique_inclusion_params?)

    # rubocop:disable Layout/LineLength
    # TODO: uncomment lines under if they more readable and clear for understanding
    # rule(:include) do
    #   key.failure(I18n.t('dry_validation.errors.invalid_inclusion_params?')) unless value.difference(available_inclusion_options).empty?
    #   key.failure(I18n.t('dry_validation.errors.unique_inclusion_params?')) unless value.eql?(value.uniq)
    # end
    # rubocop:enable Layout/LineLength
  end
end
