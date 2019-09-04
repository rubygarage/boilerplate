# frozen_string_literal: true

RSpec.describe Api::V1::Users::Sessions::Operation::Create do
  subject(:result) { described_class.call(params: params) }

  let(:params) { {} }
  let(:password) { FFaker::Internet.password }
  let(:account) { create(:account, password: password) }

  describe 'Success' do
    let(:params) { { email: account.email, password: password } }

    it 'sets tokens bundle into context' do
      expect(Api::V1::Users::Lib::Service::SessionToken::Create).to receive(:call).and_call_original
      expect(result[:semantic_success]).to eq(:created)
      expect(result[:tokens]).to include(:access, :refresh, :csrf, :access_expires_at, :refresh_expires_at)
      expect(result[:renderer]).to include(serializer: Api::V1::Lib::Serializer::Account)
      expect(result[:renderer]).to include(:meta)
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'without params' do
      let(:errors) { { email: [I18n.t('errors.key?')], password: [I18n.t('errors.key?')] } }
      let(:error_localizations) { %w[errors.key?] }

      include_examples 'errors localizations'
      include_examples 'has validation errors'
    end

    context 'with empty params' do
      let(:params) { { email: '', password: '' } }
      let(:errors) { { email: [I18n.t('errors.filled?')], password: [I18n.t('errors.filled?')] } }
      let(:error_localizations) { %w[errors.filled?] }

      include_examples 'errors localizations'
      include_examples 'has validation errors'
    end

    context 'with wrong params type' do
      let(:params) { { email: true, password: [1] } }
      let(:errors) { { email: [I18n.t('errors.str?')], password: [I18n.t('errors.str?')] } }
      let(:error_localizations) { %w[errors.str?] }

      include_examples 'errors localizations'
      include_examples 'has validation errors'
    end

    describe 'authentication errors' do
      context 'when user does not exists' do
        let(:params) { { email: "_#{account.email}", password: password } }
        let(:errors) { { base: [I18n.t('errors.session.not_found')] } }
        let(:error_localizations) { %w[errors.session.not_found] }

        include_examples 'errors localizations'
        include_examples 'has validation errors'

        it 'sets unauthorized semantic_failure marker' do
          expect(result[:semantic_failure]).to eq(:not_found)
        end
      end

      context 'when wrong credentials' do
        let(:params) { { email: account.email, password: "_#{password}" } }
        let(:errors) { { base: [I18n.t('errors.session.wrong_credentials')] } }
        let(:error_localizations) { %w[errors.session.wrong_credentials] }

        include_examples 'errors localizations'
        include_examples 'has validation errors'

        it 'sets unauthorized semantic_failure marker' do
          expect(result[:semantic_failure]).to eq(:unauthorized)
        end
      end
    end
  end
end
