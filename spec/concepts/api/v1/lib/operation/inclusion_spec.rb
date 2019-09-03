# frozen_string_literal: true

RSpec.describe Api::V1::Lib::Operation::Inclusion do
  subject(:result) do
    described_class.call(params: params, available_inclusion_options: available_inclusion_options)
  end

  let(:valid_inclusion_parameter) { 'valid_inclusion_parameter' }
  let(:inclusion_params) { valid_inclusion_parameter }
  let(:available_inclusion_options) { [valid_inclusion_parameter] }
  let(:params) { { include: inclusion_params } }

  describe 'Success' do
    context 'when inclusion parameter not passing' do
      let(:params) { {} }

      it 'skips all steps' do
        expect(result['contract.uri_query']).to be_nil
        expect(result[:inclusion_options]).to be_nil
        expect(result).to be_success
      end
    end

    context 'when valid inclusion parameter passing' do
      it 'returns succesful result' do
        expect(result['contract.uri_query']).to be_present
        expect(result['result.contract.uri_query']).to be_success
        expect(result[:inclusion_options]).to eq([inclusion_params])
        expect(result).to be_success
      end
    end
  end

  describe 'Failure' do
    include_examples 'nested inclusion errors'
  end
end
