# frozen_string_literal: true

RSpec.shared_examples 'renders unauthenticated errors' do
  context 'with invalid access/refresh token' do
    let(:headers) { {} }

    it 'renders auth errors' do
      expect(response).to be_unauthorized
      expect(response).to match_json_schema('errors')
    end
  end
end
