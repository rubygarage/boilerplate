# frozen_string_literal: true

JWTSessions.algorithm = 'HS256'
JWTSessions.encryption_key = Rails.application.credentials.dig(Rails.env.to_sym, :secret_key_base)

JWTSessions.token_store =
  if Rails.env.test?
    :memory
  else
    [:redis, { redis_url: ENV['REDIS_DB'] }]
  end
