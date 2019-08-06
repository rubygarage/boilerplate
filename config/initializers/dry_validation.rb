# frozen_string_literal: true

Dry::Validation::Schema.configure do |config|
  config.messages = :i18n
  config.input_processor = :sanitizer
end

Dry::Validation::Schema::Form.configure do |config|
  config.messages = :i18n
end
