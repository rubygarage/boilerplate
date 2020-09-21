# frozen_string_literal: true

RSpec.describe Macro do
  describe '.Decorate' do
    subject(:result) { described_class::Decorate(**params)[:task].call(ctx, **flow_options) }

    let(:flow_options) { { options: [] } }
    let(:context_target) { :model }
    let(:from) { nil }
    let(:to) { nil }
    let(:decorator) { nil }
    let(:params) { { decorator: decorator, from: from, to: to }.compact }
    let(:model) { instance_double('Object') }
    let(:other_model) { instance_double('Object') }
    let(:ctx) { { model: model, other_model: other_model, decorator: Decorator } }

    Decorator = Class.new(ApplicationDecorator) # rubocop:disable RSpec/LeakyConstantDeclaration
    OtherDecorator = Class.new(Decorator) # rubocop:disable RSpec/LeakyConstantDeclaration

    context 'when object is not enumerable, no arguments passed' do
      it 'changes context target to decorated object with decorator from context' do
        expect { result }.to change { ctx[context_target] }.from(model).to be_an_instance_of(Decorator)
      end
    end

    context 'when all arguments passed' do
      let(:from) { :other_model }
      let(:to) { :some_context }
      let(:context_target) { to }
      let(:decorator) { OtherDecorator }

      it 'creates context target with decorated object with passed decorator from passed target' do
        expect(OtherDecorator).to receive(:decorate).with(other_model).and_call_original
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

    describe 'macro id' do
      it 'has formatted id' do
        expect(described_class::Decorate({})[:id]).to macro_id_with('decorate')
      end

      it 'has uniqueness id' do
        expect(described_class::Decorate()[:id]).not_to eq(described_class::Decorate()[:id])
      end
    end
  end
end
