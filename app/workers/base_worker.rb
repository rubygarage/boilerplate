# frozen_string_literal: true

class BaseWorker
  include Sidekiq::Worker

  def perform(event)
    Raven.send_event(event)
  end
end
