# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Registrations', type: :request do
  let(:params) { { email: email, password: password, password_confirmation: password_confirmation } }
  let(:email) { FFaker::Internet.email }
  let(:password) { 'Password1!' }
  let(:password_confirmation) { password }

  path '/api/v1/users/registration' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[email password password_confirmation]
      }

      response '201', 'user created' do
        run_test! do |response|
          expect(response).to be_created
          expect(response).to match_json_schema('v1/users/registration/create')
        end
      end

      response '400', 'unprocessable entity' do
        let(:params) { {} }
        let(:email_errors) do
          [
            I18n.t('dry_schema.errors.filled?'),
            I18n.t('dry_schema.errors.max_size?', num: Constants::Shared::EMAIL_MAX_LENGTH)
          ].join(', ')
        end
        let(:password_errors) do
          [
            I18n.t('dry_schema.errors.filled?'),
            I18n.t('dry_schema.errors.min_size?', num: Constants::Shared::PASSWORD_MIN_SIZE)
          ].join(', ')
        end
        let(:bad_request_error) do
          {
            'errors' => [
              { 'detail' => email_errors,
                'source' => { 'pointer' => 'email' } },
              { 'detail' => password_errors,
                'source' => { 'pointer' => 'password' } },
              { 'detail' => I18n.t('dry_schema.errors.filled?'),
                'source' => { 'pointer' => 'password_confirmation' } }
            ]
          }
        end

        include_examples 'renders bad_request errors'
      end
    end

    describe 'N+1', :n_plus_one do
      let(:params) { { email: email, password: password, password_confirmation: password_confirmation } }

      populate { |n| create_list(:user, n) }

      specify do
        expect { post '/api/v1/users/registration', params: params, as: :json }
          .to perform_constant_number_of_queries
      end
    end
  end
end
