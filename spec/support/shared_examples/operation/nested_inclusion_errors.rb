# frozen_string_literal: true

RSpec.shared_examples 'nested inclusion errors' do
  shared_examples 'not successful operation' do
    it 'sets inclusion validation errors' do
      expect(result['contract.uri_query'].errors.messages).to eq(errors)
      expect(result).to be_failure
    end
  end

  context 'with invalid inclusion parameter' do
    let(:inclusion_params) { 'invalid_inclusion_parameter' }
    let(:errors) { { include: [I18n.t('errors.inclusion_params_valid?')] } }
    let(:error_localizations) { %w[errors.inclusion_params_valid?] }

    include_examples 'errors localizations'
    include_examples 'not successful operation'
  end

  context 'with not uniq inclusion parameters' do
    let(:params) { { include: "#{inclusion_params},#{inclusion_params}" } }
    let(:errors) { { include: [I18n.t('errors.inclusion_params_uniq?')] } }
    let(:error_localizations) { %w[errors.inclusion_params_uniq?] }

    include_examples 'errors localizations'
    include_examples 'not successful operation'
  end
end
