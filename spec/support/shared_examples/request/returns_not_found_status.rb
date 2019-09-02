# frozen_string_literal: true

RSpec.shared_examples 'returns not found status' do
  it 'returns not found status' do
    expect(response).to be_not_found
  end
end
