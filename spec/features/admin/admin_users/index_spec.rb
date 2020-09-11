# frozen_string_literal: true

RSpec.describe 'Admin->Index', type: :feature do
  let(:admin) { create(:admin_user) }
  let(:ensure_sign_in_and_visit) do
    sign_in(admin)
    visit(admin_admin_users_path)
  end

  before { ensure_sign_in_and_visit }

  it 'shows admins table' do
    within('#index_table_admin_users tbody') do
      expect(page).to have_css('tr', count: 1)
    end
  end
end
