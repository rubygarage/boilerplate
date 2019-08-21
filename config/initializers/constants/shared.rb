# frozen_string_literal: true

module Constants
  module Shared
    EMAIL_REGEX = /\A(.+)@([a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,63})\z/i.freeze
    PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[-_!@#\$%\^&\*])/.freeze
    PASSWORD_MIN_SIZE = 8
    EMAIL_MAX_LENGTH = 255
    HMAC_SECRET = Rails.env.test? ? 'test' : Rails.application.credentials.secret_key_base
  end
end
