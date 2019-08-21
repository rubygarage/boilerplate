# frozen_string_literal: true

JWTSessions.encryption_key = Constants::Shared::HMAC_SECRET
JWTSessions.token_store = Rails.env.test? ? :memory : [:redis, { redis_url: ENV['REDIS_DB'] }]
