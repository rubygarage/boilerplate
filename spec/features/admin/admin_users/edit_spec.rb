# frozen_string_literal: true

RSpec.describe 'Admin->Edit', type: :feature do
  let(:admin) { create(:admin_user) }
  let(:attributes) { attributes_for(:admin_user) }
  let(:ensure_sign_in_and_visit) do
    sign_in(admin)
    visit(edit_admin_admin_user_path(admin))
  end

  before do
    ensure_sign_in_and_visit

    fill_in('admin_user[email]', with: admin.email)
    fill_in('admin_user[password]', with: attributes[:password])
    fill_in('admin_user[password_confirmation]', with: attributes[:password])
    click_button('commit')
  end

  it 'has log in with new password' do
    fill_in(I18n.t('active_admin.devise.email.title'), with: admin.email)
    fill_in(I18n.t('active_admin.devise.password.title'), with: attributes[:password])
    click_button(I18n.t('active_admin.devise.login.title'))

    expect(page).to have_css('.flash_notice', text: I18n.t('devise.sessions.signed_in'))
  end
end
