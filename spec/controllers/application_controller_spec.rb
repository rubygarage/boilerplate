# frozen_string_literal: true

RSpec.describe ApplicationController, type: :controller do
  it { expect(described_class).to be < ActionController::Base }
end
