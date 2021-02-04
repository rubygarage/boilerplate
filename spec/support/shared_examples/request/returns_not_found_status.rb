# frozen_string_literal: true

RSpec.shared_examples 'returns not found status' do
  run_test! do |response|
    expect(response).to be_not_found
  end
end
