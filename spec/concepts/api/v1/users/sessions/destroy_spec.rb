# frozen_string_literal: true

RSpec.describe Api::V1::Users::Sessions::Operation::Destroy do
  subject(:result) { described_class.call(found_token: refresh_token) }

  describe 'Success' do
    let(:account) { create(:account) }
    let(:refresh_token) { create_token(:refresh, account: account) }

    it 'clears user session' do
      expect(Api::V1::Users::Lib::Service::SessionToken::Destroy).to receive(:call).and_call_original
      expect(result[:semantic_success]).to eq(:destroyed)
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'with invalid refresh token' do
      let(:refresh_token) { 'invalid_token' }

      it do
        expect(result[:semantic_success]).to be_nil
        expect(result).to be_failure
      end
    end
  end
end
