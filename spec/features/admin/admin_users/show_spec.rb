# frozen_string_literal: true

RSpec.describe 'Admin->Show', type: :feature do
  let(:admin) { create(:admin_user) }
  let(:ensure_sign_in_and_visit) do
    sign_in(admin)
    visit(admin_admin_user_path(admin))
  end

  before { ensure_sign_in_and_visit }

  it 'shows admin panel' do
    within("#attributes_table_admin_user_#{admin.id}") do
      expect(page).to have_css('.row-id', text: admin.id)
      expect(page).to have_css('.row-created_at', text: I18n.l(admin.created_at, format: :long))
      expect(page).to have_css('.row-email', text: admin.email)
    end
  end
end
