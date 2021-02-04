# frozen_string_literal: true

RSpec.shared_examples 'renders bad_request errors' do
  run_test! do |response|
    expect(response).to be_bad_request
    expect(response).to match_json_schema('errors')
    expect(JSON.parse(response.body)).to match_array(bad_request_error) if defined? bad_request_error
  end
end
