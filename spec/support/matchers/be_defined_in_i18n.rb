# frozen_string_literal: true

RSpec::Matchers.define(:be_defined_in_i18n) do
  match do |errors_localizations|
    errors_localizations.all? { |error| I18n.exists?(error) }
  end
end
