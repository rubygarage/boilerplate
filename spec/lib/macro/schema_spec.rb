# frozen_string_literal: true

RSpec.describe Macro do
  describe '.Schema' do
    subject(:result) { operation.call(params: params, dependency: dependency) }

    class SchemaContract < Dry::Validation::Contract
      params do
        required(:attribute).filled(:int?, gteq?: 1)
      end
    end

    class SchemaWithOptionContract < Dry::Validation::Contract
      option :dependency

      params do
        required(:attribute).filled(:int?, gteq?: 1)
      end
    end

    class SchemaContractHash < Dry::Validation::Contract
      params do
        required(:attribute).filled(:hash?)
      end
    end

    OperationWithSchemaContract = Class.new(Trailblazer::Operation) do
      step Macro::Contract::Schema(SchemaContract)
      step Trailblazer::Operation::Contract::Validate()
    end

    OperationWithSchemaContractHash = Class.new(Trailblazer::Operation) do
      step Macro::Contract::Schema(SchemaContractHash)
      step Trailblazer::Operation::Contract::Validate()
    end

    OperationWithSchemaContractInject = Class.new(Trailblazer::Operation) do
      step Macro::Contract::Schema(SchemaWithOptionContract, inject: %i[dependency])
      step Trailblazer::Operation::Contract::Validate()
    end

    let(:dependency) { {} }
    let(:params) { { attribute: 1 } }
    let(:operation) { OperationWithSchemaContract }

    context 'when valid params' do
      context 'when not data structure value' do
        let(:operation) { OperationWithSchemaContract }

        it 'sets SchemaObject to contract default, operation successful' do
          expect(result['contract.default'].errors.messages).to be_empty
          expect(result).to be_success
        end
      end

      context 'when data structure value' do
        let(:params) { { attribute: { a: 1 } } }
        let(:operation) { OperationWithSchemaContractHash }

        it 'sets SchemaObject to contract default, operation successful' do
          expect(result['contract.default'].errors.messages).to be_empty
          expect(result).to be_success
        end
      end
    end

    context 'when invalid params' do
      let(:params) { { attribute: 0 } }

      it 'sets SchemaObject to contract default, operation failure' do
        expect(result['contract.default'].errors.messages).to eq(attribute: ['must be greater than or equal to 1'])
        expect(result).to be_failure
      end
    end

    context 'when injection passed' do
      let(:dependency) { 'some_dependency' }
      let(:operation) { OperationWithSchemaContractInject }

      it 'injection exists in contract' do
        expect(result['contract.default'].schema.methods).to include(:dependency)
      end
    end

    it 'has uniqueness id' do
      expect(described_class::Contract::Schema(SchemaContract)[:id])
        .not_to eq(described_class::Contract::Schema(SchemaContract)[:id])
    end
  end

  describe 'BaseSchemaObject::NullStruct' do
    subject(:null_struct_instance) { Macro::Contract::BaseSchemaObject::NullStruct.new }

    it { expect(null_struct_instance.respond_to?(:not_existsing_method)).to be(true) }
  end
end
