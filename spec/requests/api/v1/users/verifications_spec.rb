# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Verifications', type: :request do
  let(:account) { create(:account) }
  let(:email_token) { create_token(:email, account: account) }
  let(:confirmation_url) { "/api/v1/users/verification?email_token=#{email_token}" }

  describe 'GET #show' do
    path '/api/v1/users/verification?email_token={email_token}' do
      get('show verification') do
        tags 'Users'
        produces 'application/json'
        parameter name: :email_token, in: :path, type: :string

        response(404, 'when user account not found') do
          let(:not_exising_account) { instance_double('Account', id: account.id.next) }
          let(:email_token) { create_token(:email, account: not_exising_account) }

          include_examples 'returns not found status'
        end

        response(422, 'when wrong email token') do
          let(:email_token) { 'invalid_token' }

          include_examples 'renders unprocessable entity errors'
        end

        response(204, 'successful verifies user account') do
          run_test!
        end
      end
    end

    describe 'N+1', :n_plus_one do
      before { get confirmation_url }

      populate { |n| create_list(:account, n) }

      specify do
        expect { get confirmation_url }.to perform_constant_number_of_queries
      end
    end
  end
end
