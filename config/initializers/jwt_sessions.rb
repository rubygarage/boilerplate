# frozen_string_literal: true

JWTSessions.encryption_key = Rails.application.credentials.dig(Rails.env.to_sym, :secret_key_base)
JWTSessions.token_store = Rails.env.test? ? :memory : [:redis, { redis_url: ENV['REDIS_DB'] }]
