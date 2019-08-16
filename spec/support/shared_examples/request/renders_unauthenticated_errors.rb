# frozen_string_literal: true

RSpec.shared_examples 'renders unauthenticated errors' do
  context 'when wrong credentials' do
    let(:headers) { {} }

    it 'renders auth errors' do
      expect(response).to be_unauthorized
      expect(response).to match_json_schema('v1/auth_errors')
    end
  end
end
