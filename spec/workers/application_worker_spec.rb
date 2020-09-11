# frozen_string_literal: true

RSpec.describe ApplicationWorker, type: :worker do
  it { expect(described_class.included_modules).to include(Sidekiq::Worker) }
end
