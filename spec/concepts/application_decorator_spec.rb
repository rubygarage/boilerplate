# frozen_string_literal: true

RSpec.describe ApplicationDecorator do
  it { expect(described_class).to be < Draper::Decorator }
end
