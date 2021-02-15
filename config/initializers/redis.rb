# frozen_string_literal: true

Redis.current =
  Rails.env.test? ? MockRedis.new : Redis.new(url: (ENV['REDIS_DB'] || Rails.application.credentials.redis[:db]))
