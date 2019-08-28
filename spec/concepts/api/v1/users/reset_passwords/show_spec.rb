# frozen_string_literal: true

RSpec.describe Api::V1::Users::ResetPasswords::Operation::Show do
  subject(:result) { described_class.call(params: params) }

  let(:account) { create(:account) }
  let(:email_token) { create_token(:email, account: account) }
  let(:params) { { email_token: email_token } }

  describe 'Success' do
    before { Api::V1::Users::Lib::Service::RedisAdapter.push_token(email_token) }

    it 'decrypts email token, set model' do
      expect(Api::V1::Users::Lib::Operation::DecryptEmailToken).to receive(:call).and_call_original
      expect(Api::V1::Users::Lib::Operation::CheckEmailTokenRedisEquality).to receive(:call).and_call_original
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'when email token decryption errors' do
      include_examples 'has email token decryption errors'
    end

    context 'when email token redis equality errors' do
      include_examples 'has email token equality errors'
    end
  end
end
