# frozen_string_literal: true

RSpec.describe Api::V1::Users::Lib::Service::EmailToken do
  let(:account) { instance_double('Account', id: rand(1..42)) }
  let(:account_id) { account.id }
  let(:payload) { { account_id: account_id } }

  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:ERROR_MESSAGE) }
    it { expect(described_class).to be_const_defined(:TOKEN_LIFETIME) }
    it { expect(described_class::TOKEN_LIFETIME).to eq(24.hours) }
  end

  context 'when hmac secret exists' do
    describe '.create' do
      it 'creates email token from payload' do
        expect(described_class.create(payload)).to be_an_instance_of(String)
      end
    end

    describe '.read' do
      let(:token) { create_token(:email, account: account, namespace: :namespace) }

      context 'with valid token' do
        it 'includes token payload' do
          expect(described_class.read(token)).to include(account_id: account_id)
          expect(described_class.read(token)).to include(:exp)
          expect(described_class.read(token)).to include(:namespace)
        end
      end

      context 'with invalid token' do
        it 'returns false' do
          expect(described_class.read('invalid_token')).to be(false)
        end
      end
    end
  end

  context 'when hmac secret not exists' do
    let(:error_expectation) { raise_error(RuntimeError, /Secret key is not assigned/) }

    before { stub_const('Constants::Shared::HMAC_SECRET', nil) }

    it 'raises runtime error' do
      expect { described_class.create(payload) }.to error_expectation
      expect { described_class.read(payload) }.to error_expectation
    end
  end
end
