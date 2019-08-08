# frozen_string_literal: true

RSpec.describe Api::V1::Lib::Operation::Inclusion do
  subject(:result) do
    described_class.call(params: params, available_inclusion_options: available_inclusion_options)
  end

  let(:valid_include) { 'valid_include' }
  let(:available_inclusion_options) { [valid_include] }
  let(:params) { { include: valid_include } }

  describe 'Success' do
    context 'when inclusion parameter not passing' do
      let(:params) { {} }

      it 'skips all steps' do
        expect(result['contract.uri_query']).to be_nil
        expect(result[:inclusion_options]).to be_nil
        expect(result).to be_success
      end
    end

    context 'when valid inclusion parameter passing' do
      it 'returns succesful result' do
        expect(result['contract.uri_query']).to be_present
        expect(result['result.contract.uri_query']).to be_success
        expect(result[:inclusion_options]).to eq([valid_include])
        expect(result).to be_success
      end
    end
  end

  describe 'Failure' do
    shared_examples 'not successful operation' do
      it 'sets inclusion validation errors' do
        expect(result['contract.uri_query'].errors.messages).to eq(errors)
        expect(result).to be_failure
      end
    end

    context 'with invalid inclusion parameter' do
      let(:params) { { include: 'invalid_include' } }
      let(:errors) { { include: [I18n.t('errors.inclusion_params_valid?')] } }
      let(:error_localizations) { %w[errors.inclusion_params_valid?] }

      include_examples 'errors localizations'
      include_examples 'not successful operation'
    end

    context 'with not uniq inclusion parameters' do
      let(:params) { { include: "#{valid_include},#{valid_include}" } }
      let(:errors) { { include: [I18n.t('errors.inclusion_params_uniq?')] } }
      let(:error_localizations) { %w[errors.inclusion_params_uniq?] }

      include_examples 'errors localizations'
      include_examples 'not successful operation'
    end
  end
end
