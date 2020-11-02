# frozen_string_literal: true

RSpec.describe 'RootPath' do
  context 'when visit root path' do
    before { visit(root_path) }

    it 'has redirect to admin login page' do
      expect(page).to have_current_path(new_admin_user_session_path)
    end
  end
end
