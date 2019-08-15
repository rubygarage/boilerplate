# frozen_string_literal: true

module Api::V1::Users::Sessions::Service::Tokens # rubocop:disable Style/ClassAndModuleChildren
  RSpec.describe Create do
    describe '.call' do
      subject(:service) { described_class.call(account_id: account_id) }

      let(:account_id) { rand(1..10) }
      let(:jwt_session_instance) { instance_double(JWTSessions::Session) }

      it 'delegates tokens bundle creation to JWTSessions' do
        expect(JWTSessions::Session)
          .to receive(:new)
          .with(payload: { account_id: account_id })
          .and_return(jwt_session_instance)
        expect(jwt_session_instance).to receive(:login).with(no_args)
        service
      end

      it 'returns tokens bundle' do
        expect(service).to be_an_instance_of(Hash)
        expect(service).to include(:access, :refresh, :csrf)
      end
    end
  end

  RSpec.describe Destroy do
    describe '.call' do
      subject(:service) { described_class.call(token: refresh_token) }

      let!(:refresh_token) { create_token(:refresh) }
      let(:jwt_session_instance) { instance_double(JWTSessions::Session) }

      it 'delegates tokens bundle flushing to JWTSessions' do
        expect(jwt_session_instance).to receive(:flush_by_token).with(refresh_token)
        expect(JWTSessions::Session).to receive(:new).with(no_args).and_return(jwt_session_instance)
        service
      end

      it 'flushes tokens bundle' do
        expect(service).to include(:access_expiration, :access_uid)
      end
    end
  end
end
