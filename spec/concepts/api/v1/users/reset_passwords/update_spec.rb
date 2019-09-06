# frozen_string_literal: true

RSpec.describe Api::V1::Users::ResetPasswords::Operation::Update do
  subject(:result) { described_class.call(params: params) }

  let(:account) { create(:account) }
  let(:email_token) { create_token(:email, account: account, namespace: Constants::TokenNamespace::RESET_PASSWORD) }
  let(:password) { 'Password1!' }
  let(:password_confirmation) { password }
  let(:params) { { email_token: email_token, password: password, password_confirmation: password_confirmation } }

  describe 'Success' do
    before do
      Api::V1::Users::Lib::Service::SessionToken::Create.call(
        account_id: account.id,
        namespace: Constants::TokenNamespace::SESSION
      )
      Api::V1::Users::Lib::Service::RedisAdapter.push_token(email_token)
    end

    it 'updates user account password, destroy all users sessions' do
      expect(Api::V1::Users::Lib::Operation::DecryptEmailToken).to receive(:call).and_call_original
      expect(Api::V1::Users::Lib::Operation::CheckEmailTokenRedisEquality).to receive(:call).and_call_original
      expect(Api::V1::Users::Lib::Worker::EmailNotification).to receive(:perform_async).and_call_original
      expect(Api::V1::Users::Lib::Service::RedisAdapter).to receive(:delete_token).with(email_token).and_call_original
      expect(Api::V1::Users::Lib::Service::SessionToken::DestroyAll).to receive(:call).and_call_original
      expect(result).to be_success
      expect(account.reload.authenticate(password)).to be_an_instance_of(Account)
    end
  end

  describe 'Failure' do
    context 'when password errors' do
      shared_examples 'empty params' do
        let(:errors) { { password: [I18n.t('errors.filled?')] } }
        let(:error_localizations) { %w[errors.filled?] }

        include_examples 'errors localizations'
        include_examples 'has validation errors'
      end

      before { Api::V1::Users::Lib::Service::RedisAdapter.push_token(email_token) }

      context 'without password params' do
        let(:params) { { email_token: email_token } }

        it_behaves_like 'empty params'
      end

      context 'with empty password params' do
        let(:password) { '' }

        it_behaves_like 'empty params'
      end

      context 'without password_confirmation' do
        let(:params) { { email_token: email_token, password: password } }
        let(:errors) { { password_confirmation: [I18n.t('errors.rules.user_password.eql?')] } }
        let(:error_localizations) { %w[errors.rules.user_password.eql?] }

        include_examples 'errors localizations'
        include_examples 'has validation errors'
      end

      context 'with wrong params type' do
        let(:password) { [1] }
        let(:errors) { { password: [I18n.t('errors.str?')] } }
        let(:error_localizations) { %w[errors.str?] }

        include_examples 'errors localizations'
        include_examples 'has validation errors'
      end

      context 'when password is too short' do
        let(:password) { FFaker::Internet.password[0..6] }
        let(:errors) { { password: [I18n.t('errors.min_size?', num: Constants::Shared::PASSWORD_MIN_SIZE)] } }
        let(:error_localizations) { %w[errors.min_size?] }

        include_examples 'errors localizations'
        include_examples 'has validation errors'
      end

      context 'when password does not match password pattern' do
        let(:password) { 'password' }
        let(:errors) { { password: [I18n.t('errors.format?')] } }
        let(:error_localizations) { %w[errors.format?] }

        include_examples 'errors localizations'
        include_examples 'has validation errors'
      end

      context 'when different passwords' do
        let(:password_confirmation) { "#{password}_" }
        let(:errors) { { password_confirmation: [I18n.t('errors.rules.user_password.eql?')] } }
        let(:error_localizations) { %w[errors.rules.user_password.eql?] }

        include_examples 'errors localizations'
        include_examples 'has validation errors'
      end
    end

    context 'when email token decryption errors' do
      include_examples 'has email token decryption errors'
    end

    context 'when email token redis equality errors' do
      include_examples 'has email token equality errors'
    end
  end
end
