# frozen_string_literal: true

RSpec.describe Helpers::RootHelpers, type: :helper do
  describe '#create_token' do
    let(:params) { {} }
    let(:account) { instance_double('Account', id: 'account_id') }

    describe 'email token' do
      def decode_email_token(token)
        HashWithIndifferentAccess.new(JWT.decode(token, Constants::Shared::HMAC_SECRET).first)
      end

      subject(:email_token) { create_token(:email, params) }

      context 'with default params' do
        it 'creates unexpired email token with random account id payload' do
          expect(JWT).to receive(:encode).and_call_original
          expect(email_token).to be_an_instance_of(String)
          expect(decode_email_token(email_token)).to include(:account_id, :exp)
          expect(decode_email_token(email_token)[:account_id]).to be_an_instance_of(Integer)
          expect(decode_email_token(email_token)[:namespace]).to be_nil
        end
      end

      context 'with optional params' do
        context 'with account' do
          let(:exp_time) { 1.hour.from_now.to_i }
          let(:params) { { account: account, namespace: 'namespace', exp: exp_time } }

          it 'creates unexpired email token with account_id value' do
            expect(JWT).to receive(:encode).and_call_original
            expect(email_token).to be_an_instance_of(String)
            expect(decode_email_token(email_token)).to include(:account_id, :exp)
            expect(decode_email_token(email_token)[:account_id]).to eq('account_id')
            expect(decode_email_token(email_token)[:namespace]).to eq('namespace')
            expect(decode_email_token(email_token)[:exp]).to eq(exp_time)
          end
        end

        context 'with :expired key' do
          subject(:email_token) { create_token(:email, :expired) }

          it 'creates expired email token with account_id value' do
            expect(email_token).to be_an_instance_of(String)
            expect { decode_email_token(email_token) }.to raise_error(JWT::ExpiredSignature, 'Signature has expired')
          end
        end
      end
    end

    describe 'session tokens' do
      def decode_jwt_session_token(token)
        HashWithIndifferentAccess.new(JWTSessions::Token.decode(token).first)
      end

      shared_examples 'jwt_session token' do
        subject(:token) { create_token(token_type, params) }

        context 'with default params' do
          it 'creates unexpired token with random account id payload' do
            expect(JWTSessions::Session).to receive(:new).and_call_original
            expect(token).to be_an_instance_of(String)
            expect(decode_jwt_session_token(token)).to include(*payload_keys)
          end
        end

        context 'with optional params' do
          context 'with account' do
            let(:params) { { account: account } }

            it 'creates unexpired token with account_id value' do
              expect(JWTSessions::Session).to receive(:new).and_call_original
              expect(token).to be_an_instance_of(String)
              expect(decode_jwt_session_token(token)).to include(*payload_keys)
              expect(decode_jwt_session_token(token)[:account_id]).to eq(account_id_expectation)
            end
          end

          context 'with :expired key' do
            subject(:token) { create_token(:access, :expired) }

            it 'creates expired token with account_id value' do
              expect(token).to be_an_instance_of(String)
              expect { decode_jwt_session_token(token) }
                .to raise_error(JWTSessions::Errors::ClaimsVerification, 'Signature has expired')
            end
          end
        end
      end

      describe 'access token' do
        let(:token_type) { :access }
        let(:payload_keys) { %i[account_id exp uid] }
        let(:account_id_expectation) { 'account_id' }

        it_behaves_like 'jwt_session token'
      end

      describe 'refresh token' do
        let(:token_type) { :refresh }
        let(:payload_keys) { %i[exp uid] }
        let(:account_id_expectation) { nil }

        it_behaves_like 'jwt_session token'
      end
    end
  end
end
