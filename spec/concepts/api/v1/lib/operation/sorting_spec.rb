# frozen_string_literal: true

RSpec.describe Api::V1::Lib::Operation::Sorting, type: :operation do
  subject(:result) { described_class.call(params: params, available_columns: available_columns) }

  let(:params) { {} }
  let(:available_columns) do
    create_available_columns(
      *Array.new(2) { |item| { name: "attribute_#{item.next}", sortable: true } }
    )
  end

  describe 'Success' do
    context 'when sorting parameter not passing' do
      it 'skips all steps' do
        expect(result['contract.uri_query']).to be_nil
        expect(result).to be_success
      end
    end

    context 'when valid sorting parameter passing' do
      let(:params) { { sort: 'attribute_1,-attribute_2' } }

      it 'returns succesful result' do
        expect(result['contract.uri_query']).not_to be_nil
        expect(result[:order_options]).to eq([{ attribute_1: :asc }, { attribute_2: :desc }])
        expect(result).to be_success
      end
    end
  end

  describe 'Failure' do
    shared_examples 'failed operation' do
      it 'sets sorting validation errors' do
        expect(result['contract.uri_query'].errors.messages).to eq(errors)
        expect(result).to be_failure
      end
    end

    context 'when sort not a string' do
      let(:params) { { sort: :not_a_string } }
      let(:errors) { { sort: [I18n.t('errors.str?')] } }
      let(:error_localizations) { %w[errors.str?] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end

    context 'when sort is an empty string' do
      let(:params) { { sort: '' } }
      let(:errors) { { sort: [I18n.t('errors.filled?')] } }
      let(:error_localizations) { %w[errors.filled?] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end

    context 'when sortable columnn not unique' do
      let(:params) { { sort: 'attribute_1,attribute_2,-attribute_1,-attribute_2,attribute_1' } }
      let(:errors) { { sort: [I18n.t('errors.sort_params_uniq?')] } }
      let(:error_localizations) { %w[errors.sort_params_uniq?] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end

    context 'when sortable columnn not exists' do
      let(:params) { { sort: 'nonexistent_column' } }
      let(:errors) { { sort: [I18n.t('errors.sort_params_valid?')] } }
      let(:error_localizations) { %w[errors.sort_params_valid?] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end

    context 'when invalid sortable column' do
      let(:available_columns) { create_available_columns(name: 'attribute_2', sortable: false) }

      let(:params) { { sort: 'attribute_2' } }
      let(:errors) { { sort: [I18n.t('errors.sort_params_valid?')] } }
      let(:error_localizations) { %w[errors.sort_params_valid?] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end
  end
end
