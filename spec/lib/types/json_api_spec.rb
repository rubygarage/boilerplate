# frozen_string_literal: true

module Types
  RSpec.describe JsonApi::TypeByColumn do
    subject(:type_matching_by_column_type) { described_class.call(column) }

    shared_examples 'checks value type' do
      it { expect(type_matching_by_column_type.try(value).success?).to be(true) }
    end

    context 'when column type equal to string' do
      let(:column) { :string }
      let(:value) { 'string' }

      include_examples 'checks value type'
    end

    context 'when column type equal to number' do
      let(:column) { :number }

      context 'with whole number' do
        let(:value) { 42 }

        include_examples 'checks value type'
      end

      context 'with float number' do
        let(:value) { 42.0 }

        include_examples 'checks value type'
      end
    end

    context 'when column type equal to boolean' do
      let(:column) { :boolean }
      let(:value) { '' }

      include_examples 'checks value type'
    end

    context 'when column type equal to date' do
      let(:column) { :date }

      context 'with date' do
        let(:value) { ::Date.new }

        include_examples 'checks value type'
      end

      context 'with integer' do
        let(:value) { '2000-01-01' }

        include_examples 'checks value type'
      end
    end

    context 'when column not found' do
      let(:column) { :tuple }

      it 'returns nil' do
        expect(type_matching_by_column_type).to be_nil
      end
    end
  end

  RSpec.describe JsonApi::Filter do
    subject(:result) { described_class.call(uri_filter_parameters) }

    let(:column) { 'column' }
    let(:predicate) { 'predicate' }
    let(:column_predicate) { "#{column}-#{predicate}" }
    let(:value) { 42 }
    let(:uri_filter_parameter) { [column_predicate, value] }
    let(:uri_filter_parameters) { [uri_filter_parameter] }

    it 'returns collection of filter objects' do
      expect(result).to eq([Types::FilterObject.new(column, predicate, value)])
    end
  end

  RSpec.describe JsonApi::Sort do
    subject(:result) { described_class.call(uri_sort_parameters) }

    let(:column) { 'column' }
    let(:order_prefix) { '-' }
    let(:uri_sort_parameters) { "#{column},#{order_prefix}#{column}" }

    it 'returns collection of sort objects' do
      expect(result).to eq(
        [
          Types::SortObject.new(column, :asc),
          Types::SortObject.new(column, :desc)
        ]
      )
    end
  end

  RSpec.describe JsonApi::Include do
    subject(:result) { described_class.call(uri_sort_parameter) }

    %w[attr_1 attr_2 attr_3].each { |item| let(item) { item } }
    let(:uri_sort_parameter) { "#{attr_1},#{attr_2},#{attr_3}" }

    it 'returns collection of inclusion params' do
      expect(result).to eq([attr_1, attr_2, attr_3])
    end
  end
end
