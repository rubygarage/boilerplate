# frozen_string_literal: true

RSpec.describe Api::V1::Lib::Service::EmailToken do
  let(:account) { instance_double('Account', id: rand(1..42)) }
  let(:account_id) { account.id }
  let(:payload) { { account_id: account_id } }

  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:ERROR_MESSAGE) }
  end

  context 'when hmac secret exists' do
    describe '.create' do
      it 'creates email token from payload' do
        expect(described_class.create(payload)).to be_an_instance_of(String)
      end
    end

    describe '.read' do
      let(:token) { create_token(:email, account: account) }

      it 'includes token payload' do
        expect(described_class.read(token)).to include(account_id: account_id)
      end
    end
  end

  context 'when hmac secret not exists' do
    before { stub_const('Constants::Shared::HMAC_SECRET', nil) }

    it 'raises runtime error' do
      expect { described_class.create(payload) }.to raise_error(RuntimeError, /Secret key is not assigned/)
      expect { described_class.read(payload) }.to raise_error(RuntimeError, /Secret key is not assigned/)
    end
  end
end
