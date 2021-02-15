# frozen_string_literal: true

RSpec.describe Macro do
  describe '.ModelRemove' do
    subject(:result) { described_class::ModelRemove(**params)[:task].call(ctx, **flow_options) }

    let(:sub_object) { instance_double('SubObject', destroy: true, delete: true, delete!: true, destroy!: true) }
    let(:object) { instance_double('SomeObject', sub_object: sub_object) }
    let(:params) { { path: %i[object sub_object] } }
    let(:ctx) { { object: object } }
    let(:flow_options) { { options: [] } }
    let(:dummy_destroy) { DummyDestroy.call(params: operation_params) }

    # rubocop:disable RSpec/LeakyConstantDeclaration
    DummyDestroy = Class.new(Trailblazer::Operation) do
      step Model(Account, :find_by), fail_fast: true
      step Macro::ModelRemove(path: [:model])
    end
    # rubocop:enable RSpec/LeakyConstantDeclaration

    context 'when call destroy several times' do
      let(:account) { create(:account) }
      let(:operation_params) { { id: account.id } }

      it 'access to destroy' do
        expect(dummy_destroy).to be_success
      end

      it 'has not raise error' do
        expect { dummy_destroy }.not_to raise_error
      end
    end

    context 'when model found and destroy complete successfully' do
      it 'calls :destroy on found model' do
        expect(sub_object).to receive(:destroy)
        expect(result).to be_instance_of(Array)
        expect(result.first).to be(Trailblazer::Activity::Right)
      end

      context 'when destroy with bang complete successfully' do
        let(:params) { { path: %i[object sub_object], type: :destroy! } }

        it 'calls :destroy on found model' do
          expect(sub_object).to receive(:destroy!)
          expect(result).to be_instance_of(Array)
          expect(result.first).to be(Trailblazer::Activity::Right)
        end
      end
    end

    context 'when model found and delete complete successfully' do
      let(:params) { { path: %i[object sub_object], type: :delete } }

      it 'calls :delete on found model' do
        expect(sub_object).to receive(:delete)
        expect(result).to be_instance_of(Array)
        expect(result.first).to be(Trailblazer::Activity::Right)
      end

      context 'when delete with bang complete successfully' do
        let(:params) { { path: %i[object sub_object], type: :delete! } }

        it 'calls :delete on found model' do
          expect(sub_object).to receive(:delete!)
          expect(result).to be_instance_of(Array)
          expect(result.first).to be(Trailblazer::Activity::Right)
        end
      end
    end

    context 'when model found and destroy failure' do
      let(:sub_object) { instance_double('SubObject', destroy: false) }

      it 'calls :destroy on found model' do
        expect(result).to be_instance_of(Array)
        expect(result.first).to be(Trailblazer::Activity::Left)
      end
    end

    context 'when model found and delete failure' do
      let(:params) { { path: %i[object sub_object], type: :delete } }
      let(:sub_object) { instance_double('SubObject', delete: false) }

      it 'calls :delete on found model' do
        expect(sub_object).to receive(:delete)
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

    context 'when invalid remove type' do
      let(:params) { { path: %i[object sub_object], type: :invalid } }

      it 'calls :delete on found model' do
        expect(result).to be_instance_of(Array)
        expect(result.first).to be(Trailblazer::Activity::Left)
      end
    end

    describe 'macro id' do
      it 'has formatted id' do
        expect(described_class::ModelRemove(**{})[:id]).to macro_id_with('model_remove')
      end

      it 'has uniqueness id' do
        expect(described_class::ModelRemove()[:id]).not_to eq(described_class::ModelRemove()[:id])
      end
    end
  end
end
