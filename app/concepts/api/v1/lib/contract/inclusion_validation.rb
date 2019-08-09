# frozen_string_literal: true

module Api::V1::Lib::Contract
  InclusionValidation = Dry::Validation.Schema do
    configure do
      config.type_specs = true
      option :available_inclusion_options

      def inclusion_params_uniq?(jsonapi_inclusion_params)
        jsonapi_inclusion_params.eql?(jsonapi_inclusion_params.uniq)
      end

      def inclusion_params_valid?(jsonapi_inclusion_params)
        jsonapi_inclusion_params.difference(available_inclusion_options).empty?
      end
    end

    required(:include, Types::JsonApi::Include).filled(:inclusion_params_uniq?, :inclusion_params_valid?)
  end
end
