# frozen_string_literal: true

RSpec.describe ApplicationWorker do
  it { expect(described_class.ancestors).to include(Sidekiq::Worker) }
end
