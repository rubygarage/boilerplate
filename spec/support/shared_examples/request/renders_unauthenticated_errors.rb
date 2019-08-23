# frozen_string_literal: true

RSpec.shared_examples 'renders unauthenticated errors' do
  context 'with invalid refresh token' do
    let(:headers) { { 'X-Refresh-Token': 'invalid_token' } }

    it 'renders auth errors' do
      expect(response).to be_unauthorized
      expect(response).to match_json_schema('errors')
    end
  end
end
