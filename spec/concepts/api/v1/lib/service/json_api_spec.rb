# frozen_string_literal: true

module Api::V1::Lib::Service::JsonApi # rubocop:disable Style/ClassAndModuleChildren
  RSpec.describe Column do
    subject(:column_instance) { described_class.new(params) }

    let(:column_name) { :column_name }
    let(:params) { { name: column_name } }

    context 'when required parameter passed' do
      it 'creates column instance with default params' do
        expect(column_instance).to be_an_instance_of(described_class)
        expect(column_instance.name).to eq(column_name)
        expect(column_instance.type).to eq(:string)
        expect(column_instance.filterable).to be_nil
        expect(column_instance.sortable).to be_nil
      end
    end

    context 'when all parameters passed' do
      let(:type) { :number }
      let(:filterable) { true }
      let(:sortable) { true }
      let(:params) { { name: column_name, type: type, filterable: filterable, sortable: sortable } }

      it 'creates column instance with default params' do
        expect(column_instance).to be_an_instance_of(described_class)
        expect(column_instance.name).to eq(column_name)
        expect(column_instance.type).to eq(:number)
        expect(column_instance.filterable).to eq(true)
        expect(column_instance.sortable).to eq(true)
      end
    end

    context 'when required parameter not passed' do
      let(:params) { {} }

      it { expect { column_instance }.to raise_error(ArgumentError, 'missing keyword: name') }
    end
  end

  RSpec.describe ColumnsBuilder do
    subject(:columns_builder) { described_class.call(*params) }

    let(:params) { [{ name: :name_1 }, { name: :name_2 }] }

    it 'returns collection of columns' do
      expect(columns_builder.size).to eq(params.size)
      expect(columns_builder.all? { |item| item.is_a?(Api::V1::Lib::Service::JsonApi::Column) }).to be(true)
      expect(columns_builder.map(&:to_h).first.slice(:name)).to eq(params.first)
    end
  end
end
