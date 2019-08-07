# frozen_string_literal: true

RSpec.shared_examples 'errors localizations' do
  it 'errors localizations exist in i18n' do
    expect(error_localizations).to be_defined_in_i18n
  end
end
