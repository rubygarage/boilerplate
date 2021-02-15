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
      let(:filter_options) { [{ column: filter_column, predicate: predicate, value: search_value }] }
      let(:filter_column) { 'name' }
      let(:search_value) { search_name }
      let(:search_name) { 'Uniqueness_name' }
      let!(:user) { create(:user, name: search_name) }

      before { create_list(:user, 2) }

      context 'when pass integer as value' do
        let(:search_value) { user.id }
        let(:filter_column) { 'id' }
        let(:predicate) { 'eq' }

        it 'returns users that contains search value' do
          expect(operation[:relation]).to include(user)
          expect(operation[:relation].count).to eq(1)
          expect(operation).to be_success
        end
      end

      context 'when pass datetime as value' do
        let(:search_value) { user.created_at.to_json }
        let(:filter_column) { 'created_at' }
        let(:predicate) { 'eq' }

        it 'returns users that contains search value' do
          expect(operation[:relation]).to include(user)
          expect(operation).to be_success
        end
      end

      context 'when pass array as value' do
        let(:search_value) { [user.id] }
        let(:filter_column) { 'id' }
        let(:predicate) { 'eq' }

        it 'returns users that contains search value' do
          expect(operation[:relation]).to include(user)
          expect(operation[:relation].count).to eq(1)
          expect(operation).to be_success
        end
      end

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

      context 'with contain predicate ' do
        User.class_eval do
          ransacker :created_at, type: :date do
            Arel.sql("date(created_at at time zone 'UTC' at time zone '#{Time.zone.name}')")
          end
        end

        let(:search_value) { (Date.current - 1.day).as_json }
        let(:filter_column) { 'created_at' }
        let(:predicate) { 'date_equals' }
        let!(:searchable_user) { create(:user, created_at: search_value) }

        it 'returns users that contains search value' do
          expect(operation[:relation]).to include(searchable_user)
          expect(operation[:relation].count).to eq(1)
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
