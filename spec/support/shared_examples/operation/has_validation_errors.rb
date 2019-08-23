# frozen_string_literal: true

RSpec.shared_examples 'has validation errors' do
  it 'has validation errors' do
    expect(result['contract.default'].errors.messages).to eq(errors)
    expect(result).to be_failure
  end
end
