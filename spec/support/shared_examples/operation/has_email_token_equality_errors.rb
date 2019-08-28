# frozen_string_literal: true

RSpec.shared_examples 'has email token equality errors' do
  shared_examples 'email token equality errors' do
    let(:errors) { { base: [I18n.t('errors.email_token.already_used')] } }
    let(:error_localizations) { %w[errors.email_token.already_used] }

    include_examples 'errors localizations'
    include_examples 'has validation errors'
  end

  context 'when email token not eql email token in redis' do
    before do
      Api::V1::Users::Lib::Service::RedisAdapter.push_token(
        create_token(:email, account: account, exp: 1.hour.from_now.to_i)
      )
    end

    it_behaves_like 'email token equality errors'
  end

  context 'when email token not exists in redis' do
    before { Api::V1::Users::Lib::Service::RedisAdapter.delete_token(email_token) }

    it_behaves_like 'email token equality errors'
  end
end
