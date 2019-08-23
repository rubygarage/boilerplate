# frozen_string_literal: true

RSpec.describe Service::JsonApi::ResourceErrorSerializer do
  describe 'class settings' do
    it { expect(described_class).to be < Service::JsonApi::BaseErrorSerializer }
    it { expect(described_class::ERRORS_SOURCE).to eq(Service::JsonApi::BaseErrorSerializer::ERRORS_SOURCE) }
  end

  describe '.call' do
    subject(:service) { described_class.call('contract.default' => contract) }

    let(:contract) { instance_double('Contract') }

    before { allow(contract).to receive_message_chain(:errors, :messages) { error_data_structure } }

    include_examples 'error data structure'
  end
end
