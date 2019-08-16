# frozen_string_literal: true

RSpec.describe Macro do
  describe '.AddContractError' do
    subject(:result) { operation.call({}) }

    shared_examples 'sets custom error to contract' do
      it 'sets error to ctx contract' do
        expect(result["contract.#{contract_namespace}"].errors.messages).to eq(contract_error_expecatation)
      end
    end

    context 'when contract namespace not passed' do
      let(:contract_namespace) { 'default' }
      let(:contract_error_expecatation) { { error: [I18n.t('errors.str?')] } }
      let(:operation) do
        Class.new(Trailblazer::Operation) do
          step Trailblazer::Operation::Contract::Build(constant: ApplicationContract)
          step Macro::AddContractError(error: 'errors.str?')
        end
      end

      include_examples 'sets custom error to contract'
    end

    context 'when contract namespace passed' do
      let(:contract_namespace) { 'some_namespace' }
      let(:contract_error_expecatation) { { error: [I18n.t('errors.str?')] } }
      let(:operation) do
        Class.new(Trailblazer::Operation) do
          step Trailblazer::Operation::Contract::Build(constant: ApplicationContract, name: 'some_namespace')
          step Macro::AddContractError(name: :some_namespace, error: 'errors.str?')
        end
      end

      include_examples 'sets custom error to contract'
    end

    context 'when error message is an array' do
      let(:contract_namespace) { 'default' }
      let(:contract_error_expecatation) { { error: [[:nested_error, [I18n.t('errors.str?')]]] } }
      let(:operation) do
        Class.new(Trailblazer::Operation) do
          step Trailblazer::Operation::Contract::Build(constant: ApplicationContract)
          step Macro::AddContractError(error: [:nested_error, [I18n.t('errors.str?')]])
        end
      end

      include_examples 'sets custom error to contract'
    end
  end
end
