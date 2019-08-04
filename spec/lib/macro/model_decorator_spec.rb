# frozen_string_literal: true

RSpec.describe Macro do
  describe '.ModelDecorator' do
    subject(:result) { DecoratorDummyOperation.call(params: {}, model: model) }

    # rubocop:disable RSpec/LeakyConstantDeclaration
    Decorator = Class.new(ApplicationDecorator) do
      define_method(:new_method) {}
    end

    DecoratorDummyOperation = Class.new(Trailblazer::Operation) do
      step Macro::ModelDecorator(decorator: Decorator)
    end
    # rubocop:enable RSpec/LeakyConstantDeclaration

    context 'when object is not enumerable' do
      let(:model) { instance_double('Object') }

      it 'returns decorated object' do
        expect(result[:model]).to be_an_instance_of(Decorator)
      end
    end

    context 'when object is enumerable' do
      let(:model) { [instance_double('Object')] }

      it 'returns decorated collection' do
        expect(result[:model]).to be_an_instance_of(Draper::CollectionDecorator)
      end
    end
  end
end
