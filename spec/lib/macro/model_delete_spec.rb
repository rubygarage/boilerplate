# frozen_string_literal: true

RSpec.describe Macro do
  describe '.ModelDelete' do
    subject(:result) { described_class::ModelDelete(**params)[:task].call(ctx, {}) }

    let(:sub_object) { instance_double('SubObject', delete: true) }
    let(:object) { instance_double('SomeObject', sub_object: sub_object) }
    let(:params) { { path: %i[object sub_object] } }
    let(:ctx) { { object: object } }

    context 'when model found and delete complete successfully' do
      it 'calls :delete on found model' do
        expect(result).to be_instance_of(Array)
        expect(result.first).to be(Trailblazer::Activity::Right)
      end
    end

    context 'when model found and delete failure' do
      let(:sub_object) { instance_double('SubObject', delete: false) }

      it 'calls :delete on found model' do
        expect(result).to be_instance_of(Array)
        expect(result.first).to be(Trailblazer::Activity::Left)
      end
    end

    context 'when model not found' do
      let(:params) { { path: %i[object sub_object not_existed_method] } }

      it 'calls :delete on found model' do
        expect(result).to be_instance_of(Array)
        expect(result.first).to be(Trailblazer::Activity::Left)
      end
    end
  end
end
