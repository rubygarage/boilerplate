# frozen_string_literal: true

RSpec.describe Macro do
  describe '.Inject' do
    subject(:result) { described_class::Inject(**deps)[:task].call(ctx, **flow_options) }

    let(:ctx) { {} }
    let(:deps) { { service: dependency } }
    let(:dependency_class) { 'DependencyClass' }
    let(:flow_options) { { options: [] } }

    context 'when passed string as value' do
      let(:dependency) { 'service.name' }

      it 'sets to context dependencies through dry container' do
        expect(Container).to receive(:[]).with(dependency).and_return(dependency_class)
        expect { result }
          .to change { ctx[:service] }
          .from(nil)
          .to(dependency_class)
      end
    end

    context 'when passed not string as value' do
      let(:dependency) { :service_name }

      it 'sets to context dependencies directly from value' do
        expect { result }
          .to change { ctx[:service] }
          .from(nil)
          .to(dependency)
      end
    end

    describe 'macro id' do
      it 'has formatted id' do
        expect(described_class::Inject({})[:id]).to macro_id_with('inject')
      end

      it 'has uniqueness id' do
        expect(described_class::Inject()[:id]).not_to eq(described_class::Inject()[:id])
      end
    end
  end
end
