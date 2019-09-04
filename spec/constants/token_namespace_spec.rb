# frozen_string_literal: true

RSpec.describe Constants::TokenNamespace do
  describe 'Constants::TokenNamespace::SESSION' do
    it { expect(described_class).to be_const_defined(:SESSION) }
    it { expect(described_class::SESSION).to eq('user-account') }
  end

  describe 'Constants::TokenNamespace::RESET_PASSWORD' do
    it { expect(described_class).to be_const_defined(:RESET_PASSWORD) }
    it { expect(described_class::RESET_PASSWORD).to eq('reset-password') }
  end
end
