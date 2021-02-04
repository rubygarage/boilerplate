# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Sessions', type: :request do
  let(:password) { FFaker::Internet.password }
  let(:account) { create(:account, password: password) }

  describe 'POST #create' do
    path '/api/v1/users/session' do
      post('create session') do
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

        response(201, 'successfu renders user whose session was createdl') do
          let(:params) { { email: account.email, password: password } }

          run_test! do
            expect(response).to be_created
            expect(response).to match_json_schema('v1/users/session/create')
          end
        end

        response(422, 'when wrong params') do
          let(:params) { {} }

          include_examples 'renders unprocessable entity errors'
        end

        response(401, 'when user unauthenticated') do
          let(:params) { { email: account.email, password: "_#{password}" } }
          let(:'X-Refresh-Token') { nil }

          include_examples 'renders unauthenticated errors'
        end

        response(401, 'when user account not found') do
          let(:params) { { email: "_#{account.email}", password: password } }

          run_test!
        end
      end
    end

    describe 'N+1', :n_plus_one do
      let(:params) { { email: account.email, password: password } }

      populate { |n| create_list(:account, n) }

      specify do
        expect { post '/api/v1/users/session', params: params, as: :json }
          .to perform_constant_number_of_queries
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:'X-Refresh-Token') { create_token(:refresh, account: account) }

    path '/api/v1/users/session' do
      delete('delete session') do
        tags 'Users'
        consumes 'application/json'
        parameter name: :'X-Refresh-Token', in: :header, type: :string

        response(401, 'successful clears user session') do
          let(:'X-Refresh-Token') { nil }

          include_examples 'renders unauthenticated errors'
        end

        response(204, 'successful clears user session') do
          run_test! do
            expect(response).to be_no_content
            expect(response.body).to be_empty
          end
        end
      end
    end
  end
end
