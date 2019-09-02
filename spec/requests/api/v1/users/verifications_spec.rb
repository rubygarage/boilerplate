# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Verifications', :dox, type: :request do
  include ApiDoc::V1::Users::Verification::Api

  let(:account) { create(:account) }
  let(:email_token) { create_token(:email, account: account) }
  let(:confirmation_url) { "/api/v1/users/verification?email_token=#{email_token}" }

  describe 'GET #show' do
    include ApiDoc::V1::Users::Verification::Show

    describe 'Success' do
      let(:params) { { email_token: email_token } }

      before { get confirmation_url }

      it 'verifies user account' do
        expect(response).to be_no_content
      end
    end

    describe 'Failure' do
      describe 'Unprocessable Entity' do
        let(:email_token) { 'invalid_token' }

        before { get confirmation_url }

        include_examples 'renders unprocessable entity errors'
      end

      describe 'Not found' do
        let(:params) { { email_token: email_token } }

        before do
          account.destroy
          get confirmation_url
        end

        include_examples 'returns not found status'
      end
    end
  end
end
