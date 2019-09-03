# frozen_string_literal: true

RSpec.describe 'Api::V1::Users::Account::Profiles', :dox, type: :request do
  include ApiDoc::V1::Users::Account::Profile::Api

  let!(:account) { create(:account, :with_user) }
  let(:headers) { { Authorization: auth_header(account) } }
  let(:params) { {} }

  before do
    get '/api/v1/users/account/profile', headers: headers, params: params
  end

  describe 'GET #show' do
    include ApiDoc::V1::Users::Account::Profile::Show

    describe 'Success' do
      let(:params) { { include: 'account' } }

      it 'renders user profile' do
        expect(resource_type(response)).to eq('user-profile')
        expect(response).to match_json_schema('v1/users/account/profile/show')
        expect(response).to be_ok
      end
    end

    describe 'Failure' do
      describe 'Unauthorized' do
        include_examples 'renders unauthenticated errors'
      end

      describe 'Bad Request' do
        let(:params) { { include: 'not_valid_include' } }

        include_examples 'renders uri query errors'
      end
    end
  end
end
