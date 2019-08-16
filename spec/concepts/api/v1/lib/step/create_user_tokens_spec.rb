# frozen_string_literal: true

RSpec.describe Api::V1::Lib::Step::CreateUserTokens do
  describe 'defined constants' do
    it 'NAMESPACE_PREFIX' do
      expect(described_class).to be_const_defined(:NAMESPACE_PREFIX)
      expect(described_class::NAMESPACE_PREFIX).to eq('user-account-')
    end
  end

  describe '.call' do
    subject(:shared_step) { described_class.call(ctx, model: model) }

    let(:ctx) { {} }
    let(:id) { rand(0..10) }
    let(:model) { instance_double('Account', id: id) }
    let(:jwt_sessions_instance) { instance_double(JWTSessions::Session) }
    let(:mocked_tokens_bundle) { { access: 'token', refresh: 'token', csrf: 'token' } }
    let(:account_payload) do
      {
        payload: { account_id: model.id },
        refresh_payload: { account_id: model.id },
        namespace: "#{Api::V1::Lib::Step::CreateUserTokens::NAMESPACE_PREFIX}#{id}"
      }
    end

    it 'sets tokens bundle into context' do
      expect(JWTSessions::Session).to receive(:new).with(account_payload).and_return(jwt_sessions_instance)
      expect(jwt_sessions_instance).to receive(:login).and_return(mocked_tokens_bundle)
      expect(shared_step).to eq(mocked_tokens_bundle)
      expect(ctx[:tokens]).to eq(mocked_tokens_bundle)
    end
  end
end
