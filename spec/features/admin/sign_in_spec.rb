# frozen_string_literal: true

RSpec.describe 'SignIn' do
  before { visit(new_admin_user_session_path) }

  context 'with the valid email & password' do
    let(:admin) { create(:admin_user) }

    before do
      fill_in(I18n.t('active_admin.devise.email.title'), with: admin.email)
      fill_in(I18n.t('active_admin.devise.password.title'), with: admin.password)
      click_button(I18n.t('active_admin.devise.login.title'))
    end

    it 'signed in successfully' do
      expect(page).to have_css('.flash_notice', text: I18n.t('devise.sessions.signed_in'))
    end
  end

  context 'with the invalid email or password' do
    let(:admin) { attributes_for(:admin_user) }

    before do
      fill_in(I18n.t('active_admin.devise.email.title'), with: admin[:email])
      fill_in(I18n.t('active_admin.devise.password.title'), with: admin[:password])
      click_button(I18n.t('active_admin.devise.login.title'))
    end

    it 'shows error messages' do
      expect(page).to have_css('.flash_alert', text: I18n.t('devise.failure.invalid', authentication_keys: 'Email'))
    end
  end
end
