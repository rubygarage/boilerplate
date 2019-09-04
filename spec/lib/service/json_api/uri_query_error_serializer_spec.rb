# frozen_string_literal: true

RSpec.describe Service::JsonApi::UriQueryErrorSerializer do
  describe 'class settings' do
    it { expect(described_class).to be < Service::JsonApi::BaseErrorSerializer }
    it { expect(described_class::ERRORS_SOURCE).not_to eq(Service::JsonApi::BaseErrorSerializer::ERRORS_SOURCE) }
  end

  describe '.call' do
    subject(:service) { described_class.call('contract.uri_query' => contract) }

    let(:contract) { instance_double('Contract') }

    before { allow(contract).to receive_message_chain(:errors, :messages) { contract_errors } }

    shared_examples 'serialized jsonapi resource errors' do
      it 'returns serialized jsonapi errors' do
        expect(service).to eq(serialized_errors)
      end
    end

    context 'when zero level hash' do
      let(:contract_errors) { { some_attr1: ['error'] } }
      let(:serialized_errors) do
        {
          errors: [
            {
              source: { pointer: 'some_attr1' },
              detail: 'error'
            }
          ]
        }
      end

      it_behaves_like 'serialized jsonapi resource errors'
    end

    context 'when nested 1 level hash' do
      context 'when first element is symbol' do
        let(:contract_errors) { { some_attr1: [[:some_attr2, ['error']]] } }
        let(:serialized_errors) do
          {
            errors:
              [
                {
                  detail: 'error',
                  source: { pointer: 'some_attr1[some_attr2]' }
                }
              ]
          }
        end

        it_behaves_like 'serialized jsonapi resource errors'
      end

      context 'when first element is integer' do
        let(:contract_errors) { { some_attr1: [[0, ['error']]] } }
        let(:serialized_errors) do
          {
            errors:
              [
                {
                  detail: 'error',
                  source: { pointer: 'some_attr1[0]' }
                }
              ]
          }
        end

        it_behaves_like 'serialized jsonapi resource errors'
      end
    end
  end
end
