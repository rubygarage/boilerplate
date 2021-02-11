# frozen_string_literal: true

RSpec.shared_examples 'renders uri query errors' do
  run_test! do |response|
    expect(response).to be_bad_request
    expect(response).to match_json_schema('errors')
  end
end
