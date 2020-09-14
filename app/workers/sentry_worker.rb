# frozen_string_literal: true

class SentryWorker < ApplicationWorker
  def perform(event)
    Raven.send_event(event)
  end
end
