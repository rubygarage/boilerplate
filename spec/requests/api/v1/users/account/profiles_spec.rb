# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Account::Profiles', type: :request do
  let!(:account) { create(:account, :with_user) }
  let(:authorization) { auth_header(account) }
  let(:params) { {} }

  describe 'GET #show' do
    path '/api/v1/users/account/profile/' do
      get('show profile') do
        tags 'Users'
        produces 'application/json'
        parameter name: :authorization, in: :header, type: :string

        response(401, 'when successful renders user profile') do
          let(:authorization) { nil }

          include_examples 'renders unauthenticated errors'
        end
      end
    end

    path '/api/v1/users/account/profile/?include=not_valid_include' do
      get('show profile') do
        tags 'Users'
        produces 'application/json'
        parameter name: :authorization, in: :header, type: :string

        response(400, 'when not found user profile') do
          include_examples 'renders uri query errors'
        end
      end
    end

    path '/api/v1/users/account/profile/?include=account' do
      get('show profile') do
        tags 'Users'
        produces 'application/json'
        parameter name: :authorization, in: :header, type: :string

        response(200, 'when successful renders user profile') do
          run_test! do
            expect(resource_type(response)).to eq('user-profile')
            expect(response).to match_json_schema('v1/users/account/profile/show')
            expect(response).to be_ok
          end
        end
      end
    end

    describe 'N+1', :n_plus_one do
      populate { |n| create_list(:account, n, :with_user) }

      specify do
        expect { get '/api/v1/users/account/profile', headers: headers, params: params }
          .to perform_constant_number_of_queries
      end
    end
  end
end
