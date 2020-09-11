# frozen_string_literal: true

RSpec.describe 'SignOut' do
  let(:admin) { create(:admin_user) }
  let(:ensure_sign_in_and_visit) do
    sign_in(admin)
    visit(edit_admin_admin_user_path(admin))
  end

  before { ensure_sign_in_and_visit }

  context 'when a logged in user log out' do
    before do
      within('#utility_nav') { click_link(I18n.t('active_admin.logout')) }
    end

    it 'sign out successfully' do
      expect(page).to have_css('#admin_user_email_input', text: I18n.t('active_admin.devise.email.title'))
    end
  end
end
