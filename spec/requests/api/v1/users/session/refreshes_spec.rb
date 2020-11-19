# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Sessions::Refreshes', :dox, type: :request do
  include ApiDoc::V1::Users::Session::Refresh::Api

  describe 'POST #create' do
    include ApiDoc::V1::Users::Session::Refresh::Create

    let(:account) { create(:account) }
    let(:headers) { { 'X-Refresh-Token': refresh_token } }
    let(:refresh_url) { '/api/v1/users/session/refresh' }

    before { post refresh_url, headers: headers, as: :json }

    describe 'Success' do
      let(:refresh_token) { create_token(:refresh, :expired, account: account) }

      it 'renders refreshed tokens bundle in meta' do
        expect(response).to be_created
        expect(response).to match_json_schema('v1/users/session/refresh/create')
      end
    end

    describe 'N+1', :n_plus_one do
      let(:refresh_token) { create_token(:refresh, :expired, account: account) }

      populate { |n| create_list(:account, n) }

      specify do
        expect { post refresh_url, headers: headers, as: :json }
          .to perform_constant_number_of_queries
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
