# frozen_string_literal: true

RSpec.shared_examples 'renders unprocessable entity errors' do
  context 'when invalid params' do
    it 'renders resource errors' do
      expect(response).to be_unprocessable
      expect(response).to match_json_schema('errors')
    end
  end
end
