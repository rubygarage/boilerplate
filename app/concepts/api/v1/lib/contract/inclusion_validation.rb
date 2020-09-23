# frozen_string_literal: true

module Api::V1::Lib::Contract
  class InclusionValidation < Dry::Validation::Contract
    option :available_inclusion_options

    params do
      required(:include).value(Types::JsonApi::Include)
    end

    rule(:include).validate(:invalid_inclusion_params?, :unique_inclusion_params?)

    Dry::Validation.register_macro(:invalid_inclusion_params?) do
      key.failure(:invalid_inclusion_params?) unless value.difference(available_inclusion_options).empty?
    end

    Dry::Validation.register_macro(:unique_inclusion_params?) do
      key.failure(:unique_inclusion_params?) unless value.eql?(value.uniq)
    end
  end
end
