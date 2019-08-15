# frozen_string_literal: true

RSpec.describe Api::V1::Lib::Operation::Pagination do
  subject(:result) { described_class.call(params: params, model: collection) }

  let(:collection) { (0..3).to_a }

  describe 'Success' do
    shared_examples 'successful operation' do
      it 'sets paginations params for collection' do
        expect(result[:pagy]).to be_an_instance_of(Pagy)
        expect(result).to be_success
      end
    end

    context 'without params' do
      let(:collection) { (0..50).to_a }
      let(:params) { {} }

      include_examples 'successful operation'

      it 'returns default number of items ' do
        expect(result[:model].size).to eq(Pagy::VARS[:items])
      end
    end

    context 'without params, page is nil' do
      let(:params) { { page: nil } }

      include_examples 'successful operation'
    end

    context 'without params, page is empty string' do
      let(:params) { { page: '' } }

      include_examples 'successful operation'
    end

    context 'with page number only' do
      let(:params) { { page: { number: 1 } } }

      include_examples 'successful operation'
    end

    context 'with page size only' do
      let(:params) { { page: { size: 1 } } }

      include_examples 'successful operation'
    end

    context 'with page number and size' do
      let(:params) { { page: { number: 1, size: 1 } } }

      include_examples 'successful operation'

      it 'returns array with first collection item' do
        expect(result[:model]).to eq([collection.first])
      end
    end
  end

  describe 'Failure' do
    shared_examples 'not successful operation' do
      it 'sets pagination validation errors' do
        expect(result['contract.uri_query'].errors.messages).to eq(errors)
        expect(result[:pagy]).to be_nil
        expect(result).to be_failure
      end
    end

    context 'with wrong page type' do
      let(:params) { { page: 'not_a_hash' } }
      let(:errors) { { page: [I18n.t('errors.hash?')] } }
      let(:error_localizations) { %w[errors.hash?] }

      include_examples 'errors localizations'
      include_examples 'not successful operation'
    end

    context 'with wrong page number, size types' do
      let(:params) { { page: { number: 'not_integer', size: 'not_integer' } } }
      let(:error)  { I18n.t('errors.int?') }
      let(:errors) { { page: [[:number, [error]], [:size, [error]]] } }
      let(:error_localizations) { %w[errors.int?] }

      include_examples 'errors localizations'
      include_examples 'not successful operation'
    end

    context 'with page number, size < 1' do
      let(:params) { { page: { number: 0, size: 0 } } }
      let(:error)  { I18n.t('errors.gteq?', num: JsonApi::Pagination::MINIMAL_VALUE) }
      let(:errors) { { page: [[:number, [error]], [:size, [error]]] } }
      let(:error_localizations) { %w[errors.gteq?] }

      include_examples 'errors localizations'
      include_examples 'not successful operation'
    end

    context 'when page overflow' do
      let(:params) { { page: { number: collection.size.next } } }
      let(:errors) { { page: [[:number, [I18n.t('errors.pagination_overflow')]]] } }
      let(:error_localizations) { %w[errors.pagination_overflow] }

      include_examples 'errors localizations'

      it 'sets paginations errors' do
        expect(result['contract.uri_query'].errors.messages).to eq(errors)
        expect(result[:pagy]).to be_an_instance_of(Pagy)
        expect(result).to be_failure
      end
    end
  end
end
