# frozen_string_literal: true

RSpec.describe Macro do
  describe '.Schema' do
    subject(:result) { operation.call(params: params, dependency: dependency) }

    # rubocop:disable RSpec/LeakyConstantDeclaration
    SchemaContract = Dry::Validation.Form do
      required(:attribute).filled(:int?, gteq?: 1)
    end

    SchemaContractHash = Dry::Validation.Form do
      required(:attribute).filled(:hash?)
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
      step Macro::Contract::Schema(SchemaContract, inject: %i[dependency])
      step Trailblazer::Operation::Contract::Validate()
    end
    # rubocop:enable RSpec/LeakyConstantDeclaration

    let(:dependency) { nil }
    let(:params) { { attribute: 1 } }
    let(:operation) { OperationWithSchemaContract }

    context 'when valid params' do
      context 'when not data structure value' do
        let(:operation) { OperationWithSchemaContract }

        it 'sets SchemaObject to contract default, operation successful' do
          expect(result['contract.default'].errors).to be_empty
          expect(result).to be_success
        end
      end

      context 'when data structure value' do
        let(:params) { { attribute: { a: 1 } } }
        let(:operation) { OperationWithSchemaContractHash }

        it 'sets SchemaObject to contract default, operation successful' do
          expect(result['contract.default'].errors).to be_empty
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
        expect(result['contract.default'].schema.options).to include(dependency: dependency)
      end
    end
  end

  describe 'BaseSchemaObject::NullStruct' do
    subject(:null_struct_instance) { Macro::Contract::BaseSchemaObject::NullStruct.new }

    it { expect(null_struct_instance.respond_to?(:not_existsing_method)).to be(true) }
  end
end
