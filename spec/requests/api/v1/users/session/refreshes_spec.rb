# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Sessions::Refreshes', :dox, type: :request do
  include ApiDoc::V1::Users::Session::Refresh::Api

  describe 'POST #create' do
    include ApiDoc::V1::Users::Session::Refresh::Create

    let(:account) { create(:account) }
    let(:headers) { { 'X-Refresh-Token': refresh_token } }

    before { post '/api/v1/users/session/refresh', headers: headers, as: :json }

    describe 'Success' do
      let(:refresh_token) { create_token(:refresh, :expired, account: account) }

      it 'renders refreshed tokens bundle in meta' do
        expect(response).to be_created
        expect(response).to match_json_schema('v1/users/session/refresh/create')
      end
    end

    describe 'Failure' do
      describe 'Unauthorized' do
        context 'when user unauthenticated' do
          include_examples 'renders unauthenticated errors'
        end
      end

      describe 'Forbidden' do
        context 'with unexpired access token' do
          let(:refresh_token) { create_token(:refresh, :unexpired, account: account) }

          it 'returns forbidden status' do
            expect(response).to be_forbidden
            expect(response.body).to be_empty
          end
        end
      end
    end
  end
end
