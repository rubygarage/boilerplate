# frozen_string_literal: true

RSpec.describe Api::V1::Lib::Operation::PerformFiltering do
  subject(:operation) { described_class.call(params) }

  let(:params) { { filter_options: filter_options, relation: relation } }
  let(:relation) { User.all }

  describe 'Success' do
    context 'when filter options not passed' do
      let(:filter_options) { nil }

      it 'return success result' do
        expect(operation[:relation]).to eq(relation)
        expect(operation).to be_success
      end
    end

    context 'when filter options is passed' do
      let(:filter_options) { [{ column: 'name', predicate: predicate, value: search_value }] }
      let(:search_value) { search_name }
      let(:search_name) { 'Uniqueness_name' }
      let!(:user) { create(:user, name: search_name) }

      before { create_list(:user, 2) }

      context 'when pass several filter values' do
        let(:search_value) { [search_name, search_name_2].join(',') }
        let(:search_name_2) { 'user2' }
        let(:predicate) { 'in' }
        let(:second_user) { create(:user, name: search_name_2) }

        it 'returns users that contains search value' do
          expect(operation[:relation]).to include(user, second_user)
          expect(operation).to be_success
        end
      end

      context 'with contain predicate' do
        let(:predicate) { 'cont' }

        it 'returns users that contains search value' do
          expect(operation[:relation]).to eq([user])
          expect(operation).to be_success
        end
      end

      context 'with not_in predicate' do
        let(:predicate) { 'not_in' }

        it 'returns users that contains search value' do
          expect(operation[:relation]).not_to include(user)
          expect(operation).to be_success
        end
      end
    end
  end
end
