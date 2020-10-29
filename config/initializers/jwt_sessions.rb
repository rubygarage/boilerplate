# frozen_string_literal: true

JWTSessions.encryption_key = Constants::Shared::HMAC_SECRET
JWTSessions.token_store = Rails.application.config.token_store
