# frozen_string_literal: true

RSpec.describe ApplicationJob do
  it { expect(described_class).to be < ActiveJob::Base }
end
