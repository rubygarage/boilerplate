# frozen_string_literal: true

RSpec.describe ApiController, type: :controller do
  it { expect(described_class).to be < ApplicationController }
  it { is_expected.to be_a(DefaultEndpoint) }
end
