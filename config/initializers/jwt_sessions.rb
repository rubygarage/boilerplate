# frozen_string_literal: true

JWTSessions.encryption_key, JWTSessions.token_store =
  if Rails.env.test?
    ['test', :memory]
  else
    [
      Rails.application.credentials.dig(Rails.env.to_sym, :secret_key_base),
      [:redis, { redis_url: ENV['REDIS_DB'] }]
    ]
  end
