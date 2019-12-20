# frozen_string_literal: true

RSpec.describe Macro do
  describe '.ModelDecorator' do
    subject(:result) { described_class::ModelDecorator(**params)[:task].call(ctx) }

    let(:context_target) { :model }
    let(:to) { nil }
    let(:decorator) { nil }
    let(:params) { { decorator: decorator, to: to }.compact }
    let(:model) { instance_double('Object') }
    let(:ctx) { { model: model, decorator: Decorator } }

    Decorator = Class.new(ApplicationDecorator) # rubocop:disable RSpec/LeakyConstantDeclaration
    OtherDecorator = Class.new(Decorator) # rubocop:disable RSpec/LeakyConstantDeclaration

    context 'when object is not enumerable, no arguments passed' do
      it 'changes context target to decorated object with decorator from context' do
        expect { result }.to change { ctx[context_target] }.from(model).to be_an_instance_of(Decorator)
      end
    end

    context 'when all arguments passed' do
      let(:to) { :some_context }
      let(:context_target) { to }
      let(:decorator) { OtherDecorator }

      it 'creates context target with decorated object with passed decorator' do
        expect { result }.to change { ctx[context_target] }.from(nil).to be_an_instance_of(OtherDecorator)
      end
    end

    context 'when object is enumerable' do
      let(:model) { [instance_double('Object')] }

      it 'changes context target to decorated collection' do
        expect { result }
          .to change { ctx[context_target] }
          .from(model)
          .to be_an_instance_of(Draper::CollectionDecorator)
      end
    end

    it 'has uniqueness id' do
      expect(described_class::ModelDecorator()[:id]).not_to eq(described_class::ModelDecorator()[:id])
    end
  end
end
