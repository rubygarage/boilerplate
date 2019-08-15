# frozen_string_literal: true

RSpec.describe Api::V1::Users::SessionsController, type: :controller do
  describe '#DELETE #destroy' do
    before { post :destroy }

    it { expect(response.body).to include('base', I18n.t('errors.session.invalid_token')) }
  end
end
