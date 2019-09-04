# frozen_string_literal: true

RSpec.describe Api::V1::Users::Lib::Service::RedisAdapter do
  subject(:service) { described_class.public_send(method, email_token) }

  let(:account) { instance_double('Account', id: rand(1..42)) }
  let(:namespace) { 'namespace' }
  let(:token_name) { "#{namespace}-#{account.id}" }
  let(:exp_time) { 1.hour.from_now.to_i }
  let(:email_token) { create_token(:email, account: account, exp: exp_time, namespace: namespace) }
  let(:redis_instance) { MockRedis.new }

  before { allow(Redis).to receive(:current).and_return(redis_instance) }

  shared_examples 'calls additional services' do
    it 'calls additional services' do
      expect(Api::V1::Users::Lib::Service::EmailToken).to receive(:read).and_call_original
      expect(Api::V1::Users::Lib::Service::TokenNamespace).to receive(:call).and_call_original
      service
    end
  end

  describe '.push_token' do
    let(:method) { :push_token }

    it 'pushes token to redis' do
      expect(redis_instance)
        .to receive(:setex).with(token_name, exp_time, email_token)
        .and_call_original
      expect(service).to eq('OK')
      expect(redis_instance.get(token_name)).to eq(email_token)
    end

    include_examples 'calls additional services'
  end

  describe 'find_token' do
    let(:method) { :find_token }

    before { redis_instance.set(token_name, email_token) }

    it 'findes token in redis' do
      expect(redis_instance).to receive(:get).with(token_name).and_call_original
      expect(service).to eq(email_token)
    end

    include_examples 'calls additional services'
  end

  describe 'delete_token' do
    let(:method) { :delete_token }

    before { redis_instance.set(token_name, email_token) }

    it 'findes token in redis' do
      expect(redis_instance).to receive(:del).with(token_name).and_call_original
      expect(service).to eq(1)
      expect(redis_instance.get(token_name)).to be_nil
    end

    include_examples 'calls additional services'
  end
end
