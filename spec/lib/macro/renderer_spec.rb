# frozen_string_literal: true

RSpec.describe Macro do
  describe '.Renderer' do
    subject(:result) { operation.call(params: params) }

    # rubocop:disable RSpec/LeakyConstantDeclaration
    DummyContract = Class.new(ApplicationContract) do
      property :include, virtual: true
      validation { optional(:include).maybe(:str?) }

      def include
        super.split(',').map(&:to_sym) if super # rubocop:disable Style/SafeNavigation
      end
    end

    DummyOperation = Class.new(Trailblazer::Operation) do
      step Trailblazer::Operation::Contract::Build(constant: DummyContract)
      step Trailblazer::Operation::Contract::Validate()
      step ->(ctx, **) { ctx[:some_meta] = { token: 'token' } }
      step Macro::Renderer(serializer: 'SerializerClassName', meta: :some_meta)
    end

    DummyOperationWithEmptyContract = Class.new(Trailblazer::Operation) do
      step Trailblazer::Operation::Contract::Build(constant: Class.new(ApplicationContract))
      step Trailblazer::Operation::Contract::Validate()
      step Macro::Renderer()
    end

    DummyRendererOperation = Class.new(Trailblazer::Operation) do
      step Trailblazer::Operation::Contract::Build(constant: DummyContract)
      step Trailblazer::Operation::Contract::Validate()
      step ->(ctx, **) { ctx[:some_meta] = { token: 'token' } }
      step ->(ctx, **) { ctx[:inclusion_options] = %w[str1 str2] }
      step Macro::Renderer(serializer: 'SerializerClassName', meta: :some_meta)
    end
    # rubocop:enable RSpec/LeakyConstantDeclaration

    let(:params) { {} }
    let(:operation) { DummyOperation }

    describe 'serializer cases' do
      context 'when serializer passed' do
        it 'add default serializer to result renderer' do
          expect(result[:renderer]).to include(serializer: 'SerializerClassName')
        end
      end

      context 'when serializer not passed' do
        let(:operation) { DummyOperationWithEmptyContract }

        it 'add default serializer to result renderer' do
          expect(result[:renderer]).to include(serializer: ApplicationSerializer)
        end
      end
    end

    describe 'includes cases' do
      context 'when available_inclusion_options are in ctx' do
        context 'when available_inclusion_options in ctx' do
          let(:params) { { include: 'str1,str2' } }
          let(:operation) { DummyRendererOperation }

          it 'add includes to result renderer' do
            expect(result[:renderer]).to include(include: %w[str1 str2])
          end
        end
      end

      context 'when available_inclusion_options are not in ctx' do
        let(:params) { {} }
        let(:available_inclusion_options) { nil }

        it 'not add includes to result renderer' do
          expect(result[:renderer]).not_to include(:include)
        end
      end
    end

    describe 'meta cases' do
      context 'when meta passed' do
        it 'add meta to result renderer' do
          expect(result[:renderer]).to include(meta: { token: 'token' })
        end
      end

      context 'when meta not passed' do
        let(:operation) { DummyOperationWithEmptyContract }

        it 'not add meta to result renderer' do
          expect(result[:renderer]).not_to include(:meta)
        end
      end
    end
  end
end
