# frozen_string_literal: true

RSpec.describe Macro do
  describe '.Model' do
    subject(:result) do
      described_class::Model(**params)[:task].call(ctx, flow_options)
    end

    let(:params) {}
    let(:flow_options) { {} }
    let(:item_id) { 1 }
    let(:items) { instance_double('Items') }
    let(:sub_object) { instance_double('SubObject', items: items) }
    let(:object) { instance_double('MainObject', sub_object: sub_object) }
    let(:result_model_expectation) { :found_item }

    describe 'Find relation mode' do
      context 'with default settings for find_by_key, params_key' do
        let(:params) { { entity: :object, connections: %i[sub_object items] } }
        let(:ctx) { { params: { id: item_id }, object: object } }

        context 'when model found' do
          it 'finds model and sets necessary to result.model' do
            allow(items).to receive(:find_by).with(id: item_id).and_return(result_model_expectation)
            expect { result }.to change { ctx[:model] }.from(nil).to(result_model_expectation)
            expect(result).to be_instance_of(Array)
            expect(ctx['result.model']).to be_present
            expect(ctx['result.model']).to be_success
          end
        end

        context 'when model not found' do
          it 'finds model and sets necessary to result.model' do
            allow(items).to receive(:find_by).with(id: item_id).and_return(nil)
            expect { result }.not_to change { ctx[:model] }.from(nil)
            expect(result).to be_instance_of(Array)
            expect(ctx['result.model']).to be_present
            expect(ctx['result.model']).to be_failure
          end
        end
      end

      context 'with specified settings for find_by_key, params_key' do
        let(:specified_key) { :number }
        let(:params) do
          {
            entity: :object,
            connections: %i[sub_object items],
            find_by_key: specified_key,
            params_key: specified_key
          }
        end
        let(:ctx) { { params: { specified_key => item_id }, object: object } }

        context 'when model found' do
          it 'finds model and sets necessary to result.model' do
            allow(items).to receive(:find_by).with(specified_key => item_id).and_return(result_model_expectation)
            expect { result }.to change { ctx[:model] }.from(nil).to(result_model_expectation)
            expect(result).to be_instance_of(Array)
            expect(ctx['result.model']).to be_present
            expect(ctx['result.model']).to be_success
          end
        end

        context 'when model not found' do
          it 'finds model and sets necessary to result.model' do
            allow(items).to receive(:find_by).with(specified_key => item_id).and_return(nil)
            expect { result }.not_to change { ctx[:model] }.from(nil)
            expect(result).to be_instance_of(Array)
            expect(ctx['result.model']).to be_present
            expect(ctx['result.model']).to be_failure
          end
        end
      end
    end

    describe 'Assign by relation chain mode' do
      let(:ctx) { { params: { id: item_id }, object: object } }

      context 'when connections are relation' do
        let(:params) { { entity: :object, connections: %i[sub_object items], assign: true } }

        it 'assigns returned relation to model and sets necessary result.model' do
          expect { result }.to change { ctx[:model] }.from(nil).to(items)
          expect(result).to be_instance_of(Array)
          expect(ctx['result.model']).to be_present
          expect(ctx['result.model']).to be_success
        end
      end

      context 'when connections are not relation' do
        let(:params) { { entity: :object, connections: %i[sub_object bugs], assign: true } }

        it 'sets nil to ctx[:model] and returns failure result' do
          expect { result }.not_to(change { ctx[:model] })
          expect(result).to be_instance_of(Array)
          expect(ctx['result.model']).to be_present
          expect(ctx['result.model']).to be_failure
        end
      end
    end
  end

  describe Macro::Model do
    describe '.direction' do
      subject(:result) { described_class.direction(trailblazer_result) }

      let(:trailblazer_result) { true }

      context 'when passing true' do
        it 'returns Trailblazer::Activity::Right direction' do
          expect(result).to eq(Trailblazer::Activity::Right)
        end
      end

      context 'when passing false' do
        it 'returns Trailblazer::Activity::Left direction' do
          expect(result).to eq(Trailblazer::Activity::Right)
        end
      end
    end

    describe '.result' do
      subject(:result) { described_class.result(model) }

      context 'when model is present' do
        let(:model) { instance_double('SomeObject') }

        it 'returns successful Trailblazer::Operation::Result instance' do
          expect(result).to be_instance_of(Trailblazer::Operation::Result)
          expect(result).to be_success
        end
      end

      context 'when model is not present' do
        let(:model) { nil }

        it 'returns failure Trailblazer::Operation::Result instance' do
          expect(result).to be_instance_of(Trailblazer::Operation::Result)
          expect(result).to be_failure
        end
      end
    end

    # rubocop:disable Rails/DynamicFindBy
    describe '.find_relation' do
      let(:result) { described_class.find_relation(entity, connections, find_by_key, params_key) }

      let(:items) { instance_double('Items') }
      let(:sub_object) { instance_double('SubObject', items: items) }
      let(:entity) { instance_double('MainObject', sub_object: sub_object) }
      let(:connections) { %i[sub_object items] }
      let(:find_by_key) { :id }
      let(:params_key) { 1 }
      let(:result_model_expectation) { :found_item }

      it 'returns connection found by id' do
        allow(items).to receive(:find_by).with(find_by_key => params_key).and_return(result_model_expectation)
        expect(result).to eq(result_model_expectation)
      end
    end
    # rubocop:enable Rails/DynamicFindBy
  end
end
