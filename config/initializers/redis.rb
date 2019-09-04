# frozen_string_literal: true

Redis.current =
  Rails.env.test? ? MockRedis.new : Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
