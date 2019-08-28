# frozen_string_literal: true

RSpec.describe Api::V1::Users::Sessions::Refreshes::Operation::Create do
  subject(:result) { described_class.call(found_token: refresh_token, payload: payload) }

  let(:account) { create(:account) }
  let(:payload) { { 'account_id' => account.id } }

  describe 'Success' do
    let(:refresh_token) { create_token(:refresh, :expired, account: account) }

    it 'refreshes user session' do
      expect(Api::V1::Users::Lib::Service::SessionToken::Refresh).to receive(:call).and_call_original
      expect(result[:tokens]).to include(:access, :access_expires_at, :csrf)
      expect(result[:semantic_success]).to eq(:created)
      expect(result[:renderer]).to include(:serializer, :meta)
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    shared_examples 'operation fails' do
      it 'operation fails' do
        expect(result[:tokens]).to eq(tokens_expectation)
        expect(result[:semantic_failure]).to eq(:forbidden)
        expect(result).to be_failure
      end
    end

    context 'with invalid refresh token' do
      let(:refresh_token) { 'invalid_token' }
      let(:tokens_expectation) { nil }

      include_examples 'operation fails'
    end

    context 'with unexpired refresh token' do
      let(:refresh_token) { create_token(:refresh, :unexpired, account: account) }
      let(:tokens_expectation) { false }

      include_examples 'operation fails'
    end
  end
end
