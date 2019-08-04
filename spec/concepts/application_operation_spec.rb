# frozen_string_literal: true

RSpec.describe ApplicationOperation do
  it { expect(described_class).to be < Trailblazer::Operation }
end
