# frozen_string_literal: true

RSpec.describe Api::V1::Lib::Operation::Filtering, type: :operation do
  subject(:result) do
    described_class.call(
      params: params,
      available_columns: available_columns
    )
  end

  let(:available_columns) do
    create_available_columns(
      { name: 'attribute_1', type: :string, filterable: true },
      { name: 'attribute_2', type: :number, filterable: true },
      { name: 'attribute_3', type: :boolean, filterable: true },
      { name: 'attribute_4', type: :date, filterable: true },
      { name: 'attribute_5', filterable: true } # rubocop:disable Style/BracesAroundHashParameters
    )
  end

  let(:filter_params) do
    {
      'attribute_1-string_predicate' => 'string',
      'attribute_2-number_predicate' => '1',
      'attribute_3-bool_predicate' => '',
      'attribute_4-date_predicate' => current_date,
      'attribute_5-string_predicate' => 'string'
    }
  end

  let(:default_filtering_operator) { JsonApi::Filtering::Operators::MATCH_ALL }
  let(:current_date) { Date.current.as_json }

  before do
    stub_const(
      'JsonApi::Filtering::PREDICATES',
      string: %w[string_predicate],
      number: %w[number_predicate],
      boolean: %w[bool_predicate],
      date: %w[date_predicate]
    )
  end

  describe 'Success' do
    context 'with empty params' do
      let(:params) { {} }

      it 'skips all steps' do
        expect(result['contract.uri_query']).to be_nil
        expect(result).to be_success
      end
    end

    context 'with valid params' do
      let(:filter_options_expectation) do
        [
          { column: 'attribute_1', predicate: 'string_predicate', value: 'string' },
          { column: 'attribute_2', predicate: 'number_predicate', value: '1' },
          { column: 'attribute_3', predicate: 'bool_predicate', value: '' },
          { column: 'attribute_4', predicate: 'date_predicate', value: current_date },
          { column: 'attribute_5', predicate: 'string_predicate', value: 'string' }
        ]
      end

      context 'with match (filtering operator) options' do
        let(:filtering_operator) { JsonApi::Filtering::Operators::MATCH_ANY }
        let(:params) { { filter: filter_params, match: filtering_operator } }

        it 'returns succesful result' do
          expect(result['contract.uri_query']).not_to be_nil
          expect(result[:filter_options]).to eq(filter_options_expectation)
          expect(result[:matcher_options]).to eq(filtering_operator)
          expect(result).to be_success
        end
      end

      context 'without match (filtering operator) options' do
        let(:params) { { filter: filter_params } }

        it 'returns succesful result' do
          expect(result['contract.uri_query']).not_to be_nil
          expect(result[:filter_options]).to eq(filter_options_expectation)
          expect(result[:matcher_options]).to eq(default_filtering_operator)
          expect(result).to be_success
        end
      end
    end
  end

  describe 'Failure' do
    let(:column) { 'attribute_1' }
    let(:predicate) { 'string_predicate' }
    let(:value) { 'string' }
    let(:filtering_params) { { "#{column}-#{predicate}" => value } }
    let(:filtering_operator) { default_filtering_operator }
    let(:params) { { filter: filtering_params, match: filtering_operator } }

    shared_examples 'failed operation' do
      it 'sets filtering errors' do
        expect(result['contract.uri_query'].errors.messages).to eq(errors)
        expect(result[:filter_options]).to be_nil
        expect(result).to be_failure
      end
    end

    context 'when filter is not a hash' do
      let(:filtering_params) { 'not_a_hash' }
      let(:errors) { { filter: [I18n.t('errors.hash?')] } }
      let(:error_localizations) { %w[errors.hash?] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end

    context 'when filter includes not uniq columns' do
      let(:filtering_params) do
        not_uniq_filtering_params = {}.compare_by_identity
        2.times { not_uniq_filtering_params["#{column}-#{predicate}"] = value }
        not_uniq_filtering_params
      end
      let(:errors) { { filter: [I18n.t('errors.filters_uniq?')] } }
      let(:error_localizations) { %w[errors.filters_uniq?] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end

    context 'when wrong type of match (filtering operator)' do
      let(:filtering_operator) { 1 }
      let(:errors) { { match: [I18n.t('errors.str?')] } }
      let(:error_localizations) { %w[errors.str?] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end

    context 'when match is not included in the list of available operators' do
      let(:filtering_operator) { 'unexpected' }
      let(:errors) do
        available_operators =
          "#{JsonApi::Filtering::Operators::MATCH_ALL}, #{JsonApi::Filtering::Operators::MATCH_ANY}"
        { match: [I18n.t('errors.included_in?.arg.default', list: available_operators)] }
      end
      let(:error_localizations) { %w[errors.included_in?.arg.default] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end

    context 'when invalid filterable column' do
      let(:available_columns) { create_available_columns(name: 'attribute_1', filterable: false) }

      let(:errors) { { filter: [[0, [I18n.t('errors.filtering_column_valid?')]]] } }
      let(:error_localizations) { %w[errors.filtering_column_valid?] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end

    context 'when filter contains unexpected column' do
      let(:column) { 'unexpected_column' }
      let(:errors) { { filter: [[0, [I18n.t('errors.filtering_column_valid?')]]] } }

      include_examples 'failed operation'
    end

    context 'when filter contains unexpected predicate' do
      let(:predicate) { 'unexpected_predicate' }
      let(:errors) { { filter: [[0, [I18n.t('errors.filtering_predicate_valid?')]]] } }
      let(:error_localizations) { %w[errors.filtering_predicate_valid?] }

      include_examples 'errors localizations'
      include_examples 'failed operation'
    end

    context 'when filter contains invalid value' do
      context 'when column is string' do
        let(:value) { 1 }
        let(:errors) { { filter: [[0, [I18n.t('errors.filtering_value_valid?')]]] } }
        let(:error_localizations) { %w[errors.filtering_value_valid?] }

        include_examples 'errors localizations'
        include_examples 'failed operation'
      end

      context 'when column is number' do
        let(:column) { 'attribute_2' }
        let(:predicate) { 'number_predicate' }
        let(:value) { 'string' }
        let(:errors) { { filter: [[0, [I18n.t('errors.filtering_value_valid?')]]] } }

        include_examples 'failed operation'
      end

      context 'when column is boolean' do
        let(:column) { 'attribute_3' }
        let(:predicate) { 'bool_predicate' }
        let(:value) { 'string' }
        let(:errors) { { filter: [[0, [I18n.t('errors.filtering_value_valid?')]]] } }

        include_examples 'failed operation'
      end

      context 'when column is date' do
        let(:column) { 'attribute_4' }
        let(:predicate) { 'date_predicate' }
        let(:value) { 'string' }
        let(:errors) { { filter: [[0, [I18n.t('errors.filtering_value_valid?')]]] } }

        include_examples 'failed operation'
      end
    end
  end
end
