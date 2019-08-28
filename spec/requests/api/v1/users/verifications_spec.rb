# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Verifications', :dox, type: :request do
  include ApiDoc::V1::Users::Verification::Api

  let(:account) { create(:account) }
  let(:email_token) { create_token(:email, account: account) }
  let(:confirmation_url) { "/api/v1/users/verification?email_token=#{email_token}" }

  before { get confirmation_url }

  describe 'GET #show' do
    include ApiDoc::V1::Users::Verification::Show

    describe 'Success' do
      it 'verifies user account' do
        expect(response).to be_no_content
      end
    end

    describe 'Failure' do
      describe 'Unprocessable Entity' do
        context 'when wrong params' do
          let(:email_token) { 'invalid_token' }

          include_examples 'renders unprocessable entity errors'
        end
      end

      describe 'Not found' do
        context 'when user account not found' do
          let(:not_exising_account) { instance_double('Account', id: account.id.next) }
          let(:email_token) { create_token(:email, account: not_exising_account) }

          include_examples 'returns not found status'
        end
      end
    end
  end
end
