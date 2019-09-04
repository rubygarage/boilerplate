# frozen_string_literal: true

RSpec.shared_examples 'has email token decryption errors' do
  context 'without params' do
    let(:params) { {} }
    let(:errors) { { email_token: [I18n.t('errors.key?')] } }
    let(:error_localizations) { %w[errors.key?] }

    include_examples 'errors localizations'
    include_examples 'has validation errors'
  end

  context 'with empty params' do
    let(:params) { { email_token: '' } }
    let(:errors) { { email_token: [I18n.t('errors.filled?')] } }
    let(:error_localizations) { %w[errors.filled?] }

    include_examples 'errors localizations'
    include_examples 'has validation errors'
  end

  context 'with wrong params type' do
    let(:params) { { email_token: true } }
    let(:errors) { { email_token: [I18n.t('errors.str?')] } }
    let(:error_localizations) { %w[errors.str?] }

    include_examples 'errors localizations'
    include_examples 'has validation errors'
  end

  context 'with invalid email token' do
    let(:params) { { email_token: 'invalid_token' } }
    let(:errors) { { base: [I18n.t('errors.verification.invalid_email_token')] } }
    let(:error_localizations) { %w[errors.verification.invalid_email_token] }

    include_examples 'errors localizations'
    include_examples 'has validation errors'
  end

  context 'when account not found' do
    let(:params) { { email_token: email_token } }

    before { account.destroy }

    it 'sets semantic failure not_found' do
      expect(result[:semantic_failure]).to eq(:not_found)
      expect(result).to be_failure
    end
  end
end
