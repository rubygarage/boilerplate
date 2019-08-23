# frozen_string_literal: true

RSpec.describe Api::V1::Users::Verifications::Operation::Show do
  subject(:result) { described_class.call(params: params) }

  let(:params) { {} }
  let(:account) { create(:account) }
  let(:email_token) { create_token(:email, account: account) }

  describe 'Success' do
    let(:params) { { email_token: email_token } }

    it 'verifies user account' do
      expect(Api::V1::Users::Verifications::Worker::EmailNotification).to receive(:perform_async).and_call_original
      expect { result }
        .to change { account.reload.verified }.from(false).to(true)
        .and change { User.exists?(account_id: account.id) }.from(false).to(true)
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'without params' do
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

    context 'when user account was already verified' do
      let(:params) { { email_token: email_token } }
      let(:errors) { { base: [I18n.t('errors.verification.user_account_already_verified')] } }
      let(:error_localizations) { %w[errors.verification.user_account_already_verified] }

      before { account.toggle!(:verified) } # rubocop:disable Rails/SkipsModelValidations

      include_examples 'errors localizations'
      include_examples 'has validation errors'
    end
  end
end
