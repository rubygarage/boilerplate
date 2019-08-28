# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::ResetPasswords', :dox, type: :request do
  include ApiDoc::V1::Users::ResetPassword::Api

  let(:email) { FFaker::Internet.email }
  let!(:account) { create(:account, email: email) }

  describe 'POST #create' do
    include ApiDoc::V1::Users::ResetPassword::Create

    before { post '/api/v1/users/reset_password', params: params, as: :json }

    describe 'Success' do
      let(:params) { { email: email } }

      it 'returns accepted status' do
        expect(response).to be_accepted
        expect(response.body).to be_empty
      end
    end

    describe 'Failure' do
      describe 'Unprocessable Entity' do
        context 'when wrong params' do
          let(:params) { {} }

          include_examples 'renders unprocessable entity errors'
        end
      end

      describe 'Not Found' do
        context 'when user account not found' do
          let(:params) { { email: "_#{email}" } }

          include_examples 'returns not found status'
        end
      end
    end
  end

  describe 'GET #show' do
    include ApiDoc::V1::Users::ResetPassword::Show

    let(:email_token) do
      create_token(:email, account: account, namespace: Constants::TokenNamespace::RESET_PASSWORD)
    end
    let(:reset_password_url) { "/api/v1/users/reset_password?email_token=#{email_token}" }

    before do
      Api::V1::Users::Lib::Service::RedisAdapter.push_token(email_token)
      get reset_password_url
    end

    describe 'Success' do
      it 'verifies user account' do
        expect(response).to be_no_content
        expect(response.body).to be_empty
      end
    end

    describe 'Failure' do
      describe 'Unprocessable Entity' do
        context 'when wrong params' do
          let(:email_token) { 'invalid_token' }

          include_examples 'renders unprocessable entity errors'
        end
      end

      describe 'Not found' do
        context 'when user account not found' do
          let(:not_exising_account) { instance_double('Account', id: account.id.next) }
          let(:email_token) { create_token(:email, account: not_exising_account) }

          include_examples 'returns not found status'
        end
      end
    end
  end

  describe 'PUT #update' do
    include ApiDoc::V1::Users::ResetPassword::Update

    let(:email_token) do
      create_token(:email, account: account, namespace: Constants::TokenNamespace::RESET_PASSWORD)
    end
    let(:password) { 'Password1!' }
    let(:password_confirmation) { password }
    let(:params) { { email_token: email_token, password: password, password_confirmation: password_confirmation } }

    before do
      Api::V1::Users::Lib::Service::SessionToken::Create.call(
        account_id: account.id,
        namespace: Constants::TokenNamespace::SESSION
      )
      Api::V1::Users::Lib::Service::RedisAdapter.push_token(email_token)
      put '/api/v1/users/reset_password', params: params, as: :json
    end

    describe 'Success' do
      it 'updates user account password' do
        expect(response).to be_no_content
        expect(response.body).to be_empty
      end
    end

    describe 'Failure' do
      describe 'Unprocessable Entity' do
        let(:password_confirmation) { "#{password}_" }

        include_examples 'renders unprocessable entity errors'
      end
    end
  end
end
