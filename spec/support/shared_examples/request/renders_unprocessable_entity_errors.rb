# frozen_string_literal: true

RSpec.shared_examples 'renders unprocessable entity errors' do
  run_test! do |response|
    expect(response).to be_unprocessable
    expect(response).to match_json_schema('errors')
  end
end
