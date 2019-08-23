# frozen_string_literal: true

RSpec.describe Service::JsonApi::HashErrorSerializer do
  describe 'class settings' do
    it { expect(described_class).to be < Service::JsonApi::BaseErrorSerializer }
  end

  describe '.call' do
    subject(:service) { described_class.call(error_data_structure) }

    include_examples 'error data structure'
  end
end
