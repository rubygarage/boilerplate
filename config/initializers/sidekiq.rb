# frozen_string_literal: true

require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { url:  Rails.application.credentials.redis[:db] }
end

Sidekiq.configure_server do |config|
  config.redis = { url:  Rails.application.credentials.redis[:db] }
end
