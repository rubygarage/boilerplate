# frozen_string_literal: true

RSpec.describe Api::V1::Users::Lib::Operation::CheckEmailTokenRedisEquality do
  subject(:result) { described_class.call(ctx) }

  let(:ctx) { { 'contract.default' => ApplicationContract.new({}), email_token: email_token } }
  let(:account) { create(:account) }
  let(:email_token) { create_token(:email, account: account) }
  let(:email_token1) { create_token(:email, account: account) }

  before { Api::V1::Users::Lib::Service::RedisAdapter.push_token(email_token) }

  describe '.call' do
    describe 'Success' do
      it 'check tokens equality' do
        expect(Api::V1::Users::Lib::Service::RedisAdapter).to receive(:find_token).with(email_token).and_call_original
        expect(result).to be_success
      end
    end

    describe 'Failure' do
      include_examples 'has email token equality errors'
    end
  end
end
