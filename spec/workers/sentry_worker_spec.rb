# frozen_string_literal: true

RSpec.describe SentryWorker, type: :worker do
  subject(:worker_subject) { described_class.new }

  let(:event) { 'event' }

  it 'adds job to a queue' do
    described_class.perform_async(event)
    expect(described_class).to have_enqueued_sidekiq_job(event)
  end

  it 'calls Raven.send_event with the correct arguments' do
    allow(Raven).to receive(:send_event)
    expect(Raven).to receive(:send_event).with(event)
    worker_subject.perform(event)
  end

  it { is_expected.to be_processed_in('notifiers') }
  it { is_expected.to be_retryable(true) }
end
