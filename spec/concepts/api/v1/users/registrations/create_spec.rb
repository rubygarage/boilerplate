# frozen_string_literal: true

RSpec.describe Api::V1::Users::Registrations::Operation::Create do
  subject(:result) { described_class.call(params: params) }

  let(:email) { FFaker::Internet.email }
  let(:password) { 'Password1!' }
  let(:password_confirmation) { password }
  let(:params) { { email: email, password: password, password_confirmation: password_confirmation } }

  describe 'Success' do
    it 'creates user account, sends confirmation link' do
      expect(Api::V1::Users::Lib::Service::EmailToken).to receive(:create).and_call_original
      expect(Api::V1::Users::Registrations::Worker::EmailConfirmation).to receive(:perform_async).and_call_original
      expect { result }.to change(Account, :count).from(0).to(1)
      expect(result[:semantic_success]).to eq(:created)
      expect(result[:email_token]).not_to be_nil
      expect(result[:model]).to be_persisted
      expect(result[:renderer]).to include(serializer: Api::V1::Lib::Serializer::Account)
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    shared_examples 'empty params' do
      let(:errors) { { email: [I18n.t('errors.filled?')], password: [I18n.t('errors.filled?')] } }
      let(:error_localizations) { %w[errors.filled?] }

      include_examples 'errors localizations'
      include_examples 'has validation errors'
    end

    context 'without params' do
      let(:params) { {} }

      it_behaves_like 'empty params'
    end

    context 'with empty params' do
      let(:params) { { email: '', password: '' } }

      it_behaves_like 'empty params'
    end

    context 'with wrong params type' do
      let(:params) { { email: true, password: [1] } }
      let(:errors) { { email: [I18n.t('errors.str?')], password: [I18n.t('errors.str?')] } }
      let(:error_localizations) { %w[errors.str?] }

      include_examples 'errors localizations'
      include_examples 'has validation errors'
    end

    describe 'invalid params' do
      context 'when email does not match email pattern' do
        let(:email) { "#{FFaker::Internet.email}1" }
        let(:errors) { { email: [I18n.t('errors.format?')] } }
        let(:error_localizations) { %w[errors.format?] }

        include_examples 'errors localizations'
        include_examples 'has validation errors'
      end

      context 'when email is too big' do
        let(:email) { "#{FFaker::Internet.email}#{'a' * 255}" }
        let(:errors) { { email: [I18n.t('errors.max_size?', num: Constants::Shared::EMAIL_MAX_LENGTH)] } }
        let(:error_localizations) { %w[errors.max_size?] }

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

      context 'when email not unique' do
        let(:errors) { { email: [I18n.t('errors.email_uniq?')] } }
        let(:error_localizations) { %w[errors.email_uniq?] }

        before { create(:account, email: email) }

        include_examples 'errors localizations'
        include_examples 'has validation errors'
      end
    end
  end
end
