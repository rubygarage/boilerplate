# frozen_string_literal: true

Dry::Validation.register_macro(:invalid_inclusion_params?) do
  key.failure(:invalid_inclusion_params?) unless value.difference(available_inclusion_options).empty?
end

Dry::Validation.register_macro(:unique_inclusion_params?) do
  key.failure(:unique_inclusion_params?) unless value.eql?(value.uniq)
end
