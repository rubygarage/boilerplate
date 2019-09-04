# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Registrations', :dox, type: :request do
  include ApiDoc::V1::Users::Registration::Api

  let(:email) { FFaker::Internet.email }
  let(:password) { 'Password1!' }
  let(:password_confirmation) { password }

  describe 'POST #create' do
    include ApiDoc::V1::Users::Registration::Create

    before { post '/api/v1/users/registration', params: params, as: :json }

    describe 'Success' do
      let(:params) { { email: email, password: password, password_confirmation: password_confirmation } }

      it 'renders user whose account was created' do
        expect(response).to be_created
        expect(response).to match_json_schema('v1/users/registration/create')
      end
    end

    describe 'Failure' do
      describe 'Unprocessable Entity' do
        context 'when wrong params' do
          let(:params) { {} }

          include_examples 'renders unprocessable entity errors'
        end
      end
    end
  end
end
