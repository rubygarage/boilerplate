# frozen_string_literal: true

Raven.configure do |config|
  config.dsn = Rails.application.credentials[:sentry_dsn]
  config.environments = %w[production staging]
  config.async = lambda { |event|
    SentryWorker.perform_async(event)
  }
end
