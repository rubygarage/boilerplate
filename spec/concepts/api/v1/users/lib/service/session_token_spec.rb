# frozen_string_literal: true

module Api::V1::Users::Lib::Service::SessionToken # rubocop:disable Style/ClassAndModuleChildren, Metrics/ModuleLength
  RSpec.describe Create do
    describe '.call' do
      subject(:service) { described_class.call(params) }

      let(:account_id) { rand(1..10) }
      let(:jwt_session_instance) { instance_double(JWTSessions::Session) }

      shared_examples 'returns tokens bundle' do
        it 'returns tokens bundle' do
          expect(service).to be_an_instance_of(Hash)
          expect(service).to include(:access, :access_expires_at, :refresh, :refresh_expires_at, :csrf)
        end
      end

      context 'when not namespaced token' do
        let(:params) { { account_id: account_id } }

        it 'delegates tokens bundle creation to JWTSessions' do
          expect(Api::V1::Users::Lib::Service::TokenNamespace).not_to receive(:call)
          expect(JWTSessions::Session)
            .to receive(:new)
            .with(payload: { account_id: account_id })
            .and_return(jwt_session_instance)
          expect(jwt_session_instance).to receive(:login).with(no_args)
          service
        end

        include_examples 'returns tokens bundle'
      end

      context 'when namespaced token' do
        let(:namespace) { :namespace }
        let(:params) { { account_id: account_id, namespace: namespace } }

        it 'delegates tokens bundle creation to JWTSessions' do
          expect(Api::V1::Users::Lib::Service::TokenNamespace)
            .to receive(:call)
            .with(namespace, account_id)
            .and_call_original
          expect(JWTSessions::Session)
            .to receive(:new)
            .with(payload: { account_id: account_id, namespace: "#{namespace}-#{account_id}" })
            .and_return(jwt_session_instance)
          expect(jwt_session_instance).to receive(:login).with(no_args)
          service
        end

        include_examples 'returns tokens bundle'
      end
    end
  end

  RSpec.describe Destroy do
    describe '.call' do
      subject(:service) { described_class.call(refresh_token: refresh_token) }

      let!(:refresh_token) { create_token(:refresh) }
      let(:jwt_session_instance) { instance_double(JWTSessions::Session) }

      it 'delegates tokens bundle flushing to JWTSessions' do
        expect(jwt_session_instance).to receive(:flush_by_token).with(refresh_token)
        expect(JWTSessions::Session).to receive(:new).with(no_args).and_return(jwt_session_instance)
        service
      end

      it 'flushes tokens bundle' do
        expect(service).to be_an_instance_of(Hash)
        expect(service).to include(:access_expiration, :access_uid, :expiration, :csrf)
        expect { JWTSessions::Session.new.flush_by_token(refresh_token) }
          .to raise_error(JWTSessions::Errors::Unauthorized)
      end
    end
  end

  RSpec.describe DestroyAll do
    describe '.call' do
      subject(:service) { described_class.call(namespace: namespace) }

      let(:namespace) { :namespace }
      let(:jwt_session_instance) { instance_double(JWTSessions::Session) }

      it 'delegates all tokens bundles flushing to JWTSessions' do
        expect(jwt_session_instance).to receive(:flush_namespaced).with(no_args)
        expect(JWTSessions::Session).to receive(:new).with(namespace: namespace).and_return(jwt_session_instance)
        service
      end
    end
  end

  RSpec.describe Refresh do
    describe '.call' do
      subject(:service) { described_class.call(payload: payload, refresh_token: refresh_token) }

      let(:account_id) { rand(1..10) }
      let(:account) { instance_double('Account', id: account_id) }
      let(:payload) { { 'account_id' => account_id } }
      let(:jwt_session_instance) { instance_double(JWTSessions::Session) }

      shared_examples 'JWTSessions tokens processing' do
        it 'delegates tokens bundle processing to JWTSessions' do
          expect(jwt_session_instance).to receive(:refresh).with(refresh_token).and_yield
          expect(jwt_session_instance).to receive(:flush_by_token).with(refresh_token)
          expect(JWTSessions::Session).to receive(:new).with(payload: payload).and_return(jwt_session_instance)
          service
        end
      end

      context 'with expired access token' do
        let(:refresh_token) { create_token(:refresh, :expired, account: account) }

        include_examples 'JWTSessions tokens processing'

        it 'returns refreshes tokens bundle' do
          expect(service).to be_an_instance_of(Hash)
          expect(service).to include(:access, :access_expires_at, :csrf)
        end
      end

      context 'with unexpired access token' do
        let(:refresh_token) { create_token(:refresh, account: account) }

        include_examples 'JWTSessions tokens processing'

        it 'flushes tokens bundle' do
          expect(service).to be(false)
          expect { JWTSessions::Session.new.flush_by_token(refresh_token) }
            .to raise_error(JWTSessions::Errors::Unauthorized)
        end
      end
    end
  end
end
