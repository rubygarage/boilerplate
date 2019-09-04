# frozen_string_literal: true

RSpec.describe Api::V1::Users::Lib::Operation::DecryptEmailToken do
  subject(:result) { described_class.call(params: params) }

  let(:account) { create(:account) }
  let(:email_token) { create_token(:email, account: account) }

  describe 'Success' do
    let(:params) { { email_token: email_token } }

    it 'decrypts email token, set model' do
      expect(Api::V1::Users::Lib::Service::EmailToken).to receive(:read).and_call_original
      expect(result[:model]).to be_persisted
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'when email token errors' do
      include_examples 'has email token decryption errors'
    end
  end
end
