# frozen_string_literal: true

RSpec.shared_examples 'has validation errors' do |namespace: :default|
  it 'has validation errors' do
    expect(result["contract.#{namespace}"].errors.messages).to eq(errors)
    expect(result).to be_failure
  end
end
