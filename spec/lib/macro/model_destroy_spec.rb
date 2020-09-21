# frozen_string_literal: true

RSpec.describe Macro do
  describe '.ModelDestroy' do
    subject(:result) { described_class::ModelDestroy(**params)[:task].call(ctx, **flow_options) }

    let(:sub_object) { instance_double('SubObject', destroy: true) }
    let(:object) { instance_double('SomeObject', sub_object: sub_object) }
    let(:params) { { path: %i[object sub_object] } }
    let(:ctx) { { object: object } }
    let(:flow_options) { { options: [] } }

    context 'when model found and destroy complete successfully' do
      it 'calls :destroy on found model' do
        expect(result).to be_instance_of(Array)
        expect(result.first).to be(Trailblazer::Activity::Right)
      end
    end

    context 'when model found and destroy failure' do
      let(:sub_object) { instance_double('SubObject', destroy: false) }

      it 'calls :destroy on found model' do
        expect(result).to be_instance_of(Array)
        expect(result.first).to be(Trailblazer::Activity::Left)
      end
    end

    context 'when model not found' do
      let(:params) { { path: %i[object sub_object not_existed_method] } }

      it 'calls :destroy on found model' do
        expect(result).to be_instance_of(Array)
        expect(result.first).to be(Trailblazer::Activity::Left)
      end
    end

    describe 'macro id' do
      it 'has formatted id' do
        expect(described_class::ModelDestroy(**{})[:id]).to macro_id_with('model_destroy')
      end

      it 'has uniqueness id' do
        expect(described_class::ModelDestroy()[:id]).not_to eq(described_class::ModelDestroy()[:id])
      end
    end
  end
end
