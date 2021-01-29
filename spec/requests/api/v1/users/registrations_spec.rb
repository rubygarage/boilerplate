# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Registrations', :dox, type: :request do
  include ApiDoc::V1::Users::Registration::Api

  let(:email) { FFaker::Internet.email }
  let(:password) { 'Password1!' }
  let(:password_confirmation) { password }
  let(:user_registration_url) { '/api/v1/users/registration' }

  describe 'POST #create' do
    include ApiDoc::V1::Users::Registration::Create

    before { post user_registration_url, params: params, as: :json }

    describe 'Success' do
      let(:params) { { email: email, password: password, password_confirmation: password_confirmation } }

      it 'renders user whose account was created' do
        expect(response).to be_created
        expect(response).to match_json_schema('v1/users/registration/create')
      end
    end

    describe 'N+1', :n_plus_one do
      let(:params) { { email: email, password: password, password_confirmation: password_confirmation } }

      populate { |n| create_list(:user, n) }

      specify do
        expect { post user_registration_url, params: params, as: :json }
          .to perform_constant_number_of_queries
      end
    end

    describe 'Failure' do
      describe 'Unprocessable Entity' do
        context 'when wrong params' do
          let(:params) { {} }
          let(:bad_request_error) do
            {
              'errors' => [
                { 'detail' => I18n.t('errors.filled?'),
                  'source' => { 'pointer' => 'email' } },
                { 'detail' => I18n.t('errors.filled?'),
                  'source' => { 'pointer' => 'password' } }
              ]
            }
          end

          include_examples 'renders bad_request errors'
        end
      end
    end
  end
end
