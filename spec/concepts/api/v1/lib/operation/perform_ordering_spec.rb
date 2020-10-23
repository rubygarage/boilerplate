# frozen_string_literal: true

RSpec.describe Api::V1::Lib::Operation::PerformOrdering do
  subject(:operation) { described_class.call(params) }

  let(:params) { { order_options: order_options, relation: relation } }
  let(:relation) { User.all }

  describe 'Success' do
    context 'when ordering options not passed' do
      let(:order_options) { nil }

      it 'return success result' do
        expect(operation[:relation]).to eq(relation)
        expect(operation).to be_success
      end
    end

    context 'when order options is passed' do
      let(:order_options) { { name: :desc } }

      before { create_list(:user, 3) }

      it 'returns ordered relation' do
        expect(operation[:relation].to_a).to eq(User.all.order(name: :desc).to_a)
        expect(operation).to be_success
      end
    end
  end
end
