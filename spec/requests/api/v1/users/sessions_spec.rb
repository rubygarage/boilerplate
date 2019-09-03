# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Sessions', :dox, type: :request do
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
        expect(response).to match_json_schema('v1/users/session/create')
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
          let(:params) { { email: "_#{account.email}", password: password } }

          it 'returns not found status' do
            expect(response).to be_not_found
          end
        end
      end

      describe 'Unauthorized' do
        context 'when user unauthenticated' do
          let(:params) { { email: account.email, password: "_#{password}" } }

          include_examples 'renders unauthenticated errors'
        end
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

    describe 'Failure' do
      describe 'Unauthorized' do
        context 'when user unauthenticated' do
          include_examples 'renders unauthenticated errors'
        end
      end
    end
  end
end
