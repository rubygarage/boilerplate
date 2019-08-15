# frozen_string_literal: true

RSpec.describe ApiController, type: :controller do
  describe 'class settings' do
    it { expect(described_class).to be < ApplicationController }
    it { is_expected.to be_a(DefaultEndpoint) }
    it { is_expected.to be_a(Authentication) }
    it { is_expected.to be_a(JWTSessions::RailsAuthorization) }
  end
end
