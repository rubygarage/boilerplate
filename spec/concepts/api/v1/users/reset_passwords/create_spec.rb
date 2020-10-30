# frozen_string_literal: true

RSpec.describe Api::V1::Users::ResetPasswords::Operation::Create do
  subject(:result) { described_class.call(params: params) }

  let(:params) { {} }
  let(:email) { FFaker::Internet.email }

  before { create(:account, email: email) }

  describe 'Success' do
    let(:params) { { email: email } }

    it 'creates and email reset password token' do
      expect(Api::V1::Users::Lib::Service::EmailToken).to receive(:create).and_call_original
      expect(Api::V1::Users::Lib::Service::RedisAdapter).to receive(:push_token).and_call_original
      expect(Api::V1::Users::ResetPasswords::Worker::EmailResetPasswordUrl).to receive(:perform_async).and_call_original
      expect(result[:semantic_success]).to eq(:accepted)
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'without params' do
      let(:errors) { { email: [I18n.t('errors.key?')] } }

      include_examples 'has validation errors'
    end

    context 'with empty params' do
      let(:params) { { email: '' } }
      let(:errors) { { email: [I18n.t('errors.filled?')] } }

      include_examples 'has validation errors'
    end

    context 'with wrong params type' do
      let(:params) { { email: true } }
      let(:errors) { { email: [I18n.t('errors.str?')] } }

      include_examples 'has validation errors'
    end

    context 'when account not found' do
      let(:errors) { { email: [I18n.t('errors.reset_password.email_not_found')] } }
      let(:params) { { email: "_#{email}" } }

      include_examples 'has validation errors'

      it 'sets semantic failure not_found' do
        expect(result[:semantic_failure]).to eq(:not_found)
      end
    end
  end
end
