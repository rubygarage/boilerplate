# frozen_string_literal: true

class ApplicationContract < Dry::Validation::Contract
  # feature Reform::Form::Dry
  config.messages.default_locale = :en
  config.messages.backend = :i18n
end
