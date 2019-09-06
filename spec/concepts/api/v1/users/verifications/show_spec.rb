# frozen_string_literal: true

RSpec.describe Api::V1::Users::Verifications::Operation::Show do
  subject(:result) { described_class.call(params: params) }

  let(:account) { create(:account) }
  let(:email_token) { create_token(:email, account: account) }
  let(:params) { { email_token: email_token } }

  describe 'Success' do
    it 'verifies user account' do
      expect(Api::V1::Users::Lib::Operation::DecryptEmailToken).to receive(:call).and_call_original
      expect(Api::V1::Users::Lib::Worker::EmailNotification).to receive(:perform_async).and_call_original
      expect { result }
        .to change { account.reload.verified }.from(false).to(true)
        .and change { User.exists?(account_id: account.id) }.from(false).to(true)
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'when email token errors' do
      let(:params) { {} }

      include_examples 'has email token decryption errors'
    end

    context 'when user account was already verified' do
      let(:errors) { { base: [I18n.t('errors.verification.user_account_already_verified')] } }
      let(:error_localizations) { %w[errors.verification.user_account_already_verified] }

      before { account.toggle!(:verified) } # rubocop:disable Rails/SkipsModelValidations

      include_examples 'errors localizations'
      include_examples 'has validation errors'
    end
  end
end
