# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Session::Refreshes', type: :request do
  let(:account) { create(:account) }

  describe 'POST #create' do
    path '/api/v1/users/session/refresh' do
      post('create refresh') do
        tags 'Users'
        consumes 'application/json'
        parameter name: :'X-Refresh-Token', in: :header, type: :string

        response(403, 'when unexpired access token') do
          let(:'X-Refresh-Token') { create_token(:refresh, :unexpired, account: account) }

          run_test! do
            expect(response).to be_forbidden
            expect(response.body).to be_empty
          end
        end

        response(401, 'when user unauthenticated') do
          let(:'X-Refresh-Token') { nil }

          include_examples 'renders unauthenticated errors'
        end

        response(201, 'successful renders refreshed tokens bundle in meta') do
          let(:'X-Refresh-Token') { create_token(:refresh, :expired, account: account) }

          run_test! do
            expect(response).to be_created
            expect(response).to match_json_schema('v1/users/session/refresh/create')
          end
        end
      end
    end

    describe 'N+1', :n_plus_one do
      let(:headers) { { 'X-Refresh-Token': refresh_token } }
      let(:refresh_token) { create_token(:refresh, :expired, account: account) }

      populate { |n| create_list(:account, n) }

      specify do
        expect { post '/api/v1/users/session/refresh', headers: headers, as: :json }
          .to perform_constant_number_of_queries
      end
    end
  end
end
