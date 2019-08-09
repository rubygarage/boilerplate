# frozen_string_literal: true

RSpec.describe Service::JsonApi::ResourceErrorSerializer do
  describe 'class settings' do
    it { expect(described_class).to be < Service::JsonApi::BaseErrorSerializer }
    it { expect(described_class::ERRORS_SOURCE).to eq(Service::JsonApi::BaseErrorSerializer::ERRORS_SOURCE) }
  end

  describe '.call' do
    subject(:service) { described_class.call('contract.default' => contract) }

    shared_examples 'serialized jsonapi resource errors' do
      it 'returns serialized jsonapi errors' do
        expect(service).to eq(serialized_errors)
      end
    end

    let(:error)    { 'error' }
    let(:contract) { instance_double('Contract') }

    before { allow(contract).to receive_message_chain(:errors, :messages) { contract_errors } }

    context 'when zero level hash' do
      let(:contract_errors) { { some_attr: ['error'] } }
      let(:serialized_errors) do
        {
          errors: [
            {
              source:
              {
                pointer: '/some_attr'
              },
              detail: 'error'
            }
          ]
        }
      end

      it_behaves_like 'serialized jsonapi resource errors'
    end

    context 'when 1 depth: array' do
      let(:contract_errors) { { some_attr_1: [[:some_attr_2, [error, error]], [:some_attr_3, [error]]] } }
      let(:serialized_errors) do
        {
          errors: [
            {
              detail: "#{error}, #{error}",
              source: {
                pointer: '/some_attr_1/some_attr_2'
              }
            },
            {
              detail: error,
              source: {
                pointer: '/some_attr_1/some_attr_3'
              }
            }
          ]
        }
      end

      it_behaves_like 'serialized jsonapi resource errors'
    end

    context 'when 2 depth: array-hash' do
      let(:contract_errors) do
        {
          some_attr_1: [
            [:some_attr_2, { some_attr_3: [error, error], some_attr_4: [error] }],
            [:some_attr_5, { some_attr_6: [error] }]
          ]
        }
      end
      let(:serialized_errors) do
        {
          errors: [
            {
              detail: "#{error}, #{error}",
              source: {
                pointer: '/some_attr_1/some_attr_2/some_attr_3'
              }
            },
            {
              detail: error,
              source: {
                pointer: '/some_attr_1/some_attr_2/some_attr_4'
              }
            },
            {
              detail: error,
              source: {
                pointer: '/some_attr_1/some_attr_5/some_attr_6'
              }
            }
          ]
        }
      end

      it_behaves_like 'serialized jsonapi resource errors'
    end

    context 'when 1 depth: hash' do
      let(:contract_errors) do
        {
          some_attr_1: [
            [:some_attr_2, [error]],
            [:some_attr_3, [error, error]]
          ]
        }
      end
      let(:serialized_errors) do
        {
          errors: [
            {
              detail: error,
              source: {
                pointer: '/some_attr_1/some_attr_2'
              }
            },
            {
              detail: "#{error}, #{error}",
              source: {
                pointer: '/some_attr_1/some_attr_3'
              }
            }
          ]
        }
      end

      it_behaves_like 'serialized jsonapi resource errors'
    end

    context 'when 4 depth: array-hash-array-hash' do
      let(:contract_errors) do
        {
          attr_1: [
            [:attr_2, { attr_3: [error], attr_4: { attr_5: { attr_6: [error, error], attr_7: [error] } } }]
          ]
        }
      end
      let(:serialized_errors) do
        {
          errors: [
            {
              detail: error,
              source: {
                pointer: '/attr_1/attr_2/attr_3'
              }
            },
            {
              detail: "#{error}, #{error}",
              source: {
                pointer: '/attr_1/attr_2/attr_4/attr_5/attr_6'
              }
            },
            {
              detail: error,
              source: {
                pointer: '/attr_1/attr_2/attr_4/attr_5/attr_7'
              }
            }
          ]
        }
      end

      it_behaves_like 'serialized jsonapi resource errors'
    end
  end
end
