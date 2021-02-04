# frozen_string_literal: true

RSpec.shared_examples 'renders unauthenticated errors' do
  run_test! do
    expect(response).to be_unauthorized
    expect(response).to match_json_schema('errors')
  end
end
