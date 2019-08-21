# frozen_string_literal: true

module Api::V1::Lib::Service
  class EmailToken
    ERROR_MESSAGE = 'Secret key is not assigned'

    class << self
      def create(payload, exp = 24.hours.from_now)
        check_secret_key
        payload[:exp] = exp.to_i
        JWT.encode(payload, Constants::Shared::HMAC_SECRET)
      end

      def read(token)
        check_secret_key
        body = JWT.decode(token, Constants::Shared::HMAC_SECRET).first
        HashWithIndifferentAccess.new(body)
      end

      private

      def check_secret_key
        raise ERROR_MESSAGE unless Constants::Shared::HMAC_SECRET
      end
    end
  end
end
