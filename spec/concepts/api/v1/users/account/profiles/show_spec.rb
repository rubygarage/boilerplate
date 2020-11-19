# frozen_string_literal: true

RSpec.describe Api::V1::Users::Account::Profiles::Operation::Show do
  subject(:result) { described_class.call(params: params, current_account: account) }

  let(:account) { create(:account, :with_user) }
  let(:inclusion_params) { 'account' }
  let(:params) { { include: inclusion_params } }

  describe 'Success' do
    it 'prepares data for user profile rendering' do
      expect(Api::V1::Lib::Operation::Inclusion).to receive(:call).and_call_original
      expect(result[:model]).to eq(account.user)
      expect(result[:available_inclusion_options]).to eq(%w[account])
      expect(result).to be_success
    end
  end

  describe 'Failure' do
    context 'when inclusion errors' do
      include_examples 'nested inclusion errors'
    end
  end
end
