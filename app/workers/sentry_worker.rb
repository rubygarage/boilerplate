# frozen_string_literal: true

class SentryWorker
  include Sidekiq::Worker

  sidekiq_options queue: :notifiers

  def perform(event)
    Raven.send_event(event)
  end
end
