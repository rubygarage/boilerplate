# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::ResetPasswords', type: :request do
  let(:email) { FFaker::Internet.email }
  let!(:account) { create(:account, email: email) }

  describe 'GET #show' do
    let(:email_token) do
      create_token(:email, account: account, namespace: Constants::TokenNamespace::RESET_PASSWORD)
    end

    path '/api/v1/users/reset_password/?email_token={email_token}' do
      get 'show reset_password' do
        tags 'Users'
        produces 'application/json'
        parameter name: :email_token, in: :path, type: :string

        before { Api::V1::Users::Lib::Service::RedisAdapter.push_token(email_token) }

        response(204, 'Successful') do
          run_test! do
            expect(response).to be_no_content
            expect(response.body).to be_empty
          end
        end

        response(422, 'Unprocessable Entity') do
          let(:email_token) { 'invalid_token' }

          include_examples 'renders unprocessable entity errors'
        end

        response(404, 'Unprocessable Entity') do
          let(:not_exising_account) { instance_double('Account', id: account.id.next) }
          let(:email_token) { create_token(:email, account: not_exising_account) }

          include_examples 'returns not found status'
        end
      end
    end

    describe 'N+1', :n_plus_one do
      populate { |n| create_list(:account, n) }

      specify do
        expect { get "/api/v1/users/reset_password?email_token=#{email_token}" }.to perform_constant_number_of_queries
      end
    end
  end

  describe 'POST #create' do
    path '/api/v1/users/reset_password/' do
      post('create reset_password') do
        tags 'Users'
        consumes 'application/json'
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            email: { type: :string }
          },
          required: ['email']
        }

        response(202, 'successful') do
          let(:params) { { email: email } }

          run_test! do |response|
            expect(response).to be_accepted
            expect(response.body).to be_empty
          end
        end

        response(422, 'when wrong params') do
          let(:params) { {} }

          include_examples 'renders unprocessable entity errors'
        end

        response(404, 'user account not found') do
          let(:params) { { email: "_#{email}" } }

          include_examples 'returns not found status'
        end
      end
    end

    describe 'N+1', :n_plus_one do
      let(:params) { { email: email } }

      populate { |n| create_list(:account, n) }

      specify do
        expect { post '/api/v1/users/reset_password', params: params, as: :json }
          .to perform_constant_number_of_queries
      end
    end
  end

  describe 'PUT #update' do
    path '/api/v1/users/reset_password/' do
      put('update reset_password') do
        tags 'Users'
        consumes 'application/json'
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            email_token: { type: :string },
            password: { type: :string },
            password_confirmation: { type: :string }
          },
          required: %w[email_token password password_confirmation]
        }

        let(:email_token) do
          create_token(:email, account: account, namespace: Constants::TokenNamespace::RESET_PASSWORD)
        end
        let(:password) { 'Password1!' }
        let(:password_confirmation) { password }
        let(:params) { { email_token: email_token, password: password, password_confirmation: password_confirmation } }

        before do
          Api::V1::Users::Lib::Service::SessionToken.create(
            account_id: account.id,
            namespace: Constants::TokenNamespace::SESSION
          )
          Api::V1::Users::Lib::Service::RedisAdapter.push_token(email_token)
        end

        response(204, 'successful updates user account password') do
          run_test! do
            expect(response).to be_no_content
            expect(response.body).to be_empty
          end
        end

        response(422, 'successful updates user account password') do
          let(:password_confirmation) { "#{password}_" }

          include_examples 'renders unprocessable entity errors'
        end
      end
    end
  end
end
