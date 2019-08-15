# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Sessions::Operation::Create', :dox, type: :request do
  include ApiDoc::V1::Users::Session::Api

  let(:password) { FFaker::Internet.password }
  let(:account) { create(:account, password: password) }

  describe 'POST #create' do
    include ApiDoc::V1::Users::Session::Create

    before { post '/api/v1/users/session', params: params, as: :json }

    describe 'Success' do
      let(:params) { { email: account.email, password: password } }

      it 'renders user whose session was created' do
        expect(response).to be_created
        expect(response.body).to match_json_schema('v1/users/sessions/create')
      end
    end

    describe 'Failure' do
      describe 'Unprocessable Entity' do
        let(:params) { {} }

        include_examples 'renders unprocessable entity errors'
      end

      describe 'Not Found' do
        let(:params) { { email: "_#{account.email}", password: password } }

        it 'returns not found status' do
          expect(response).to be_not_found
        end
      end

      describe 'Unauthorized' do
        let(:params) { { email: account.email, password: "_#{password}" } }

        include_examples 'renders unauthenticated errors'
      end
    end
  end

  describe 'DELETE #destroy' do
    include ApiDoc::V1::Users::Session::Destroy

    let(:headers) { { 'X-Refresh-Token': create_token(:refresh, account: account) } }

    before { delete '/api/v1/users/session', headers: headers, as: :json }

    describe 'Success' do
      it 'clears user session' do
        expect(response).to be_no_content
        expect(response.body).to be_empty
      end
    end

    describe 'Fail' do
      describe 'Unauthorized' do
        let(:headers) { { 'X-Refresh-Token': 'wrong_token' } }

        include_examples 'renders unauthenticated errors'
      end
    end
  end
end
