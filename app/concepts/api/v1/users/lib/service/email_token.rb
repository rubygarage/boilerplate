# frozen_string_literal: true

module Api::V1::Users::Lib::Service
  class EmailToken
    ERROR_MESSAGE = 'Secret key is not assigned'
    TOKEN_LIFETIME = 24.hours

    class << self
      def create(payload, exp = TOKEN_LIFETIME.from_now.to_i)
        check_secret_key
        payload[:exp] = exp
        JWT.encode(payload, Constants::Shared::HMAC_SECRET)
      end

      def read(token)
        check_secret_key
        body = JWT.decode(token, Constants::Shared::HMAC_SECRET).first rescue false
        return body unless body

        HashWithIndifferentAccess.new(body)
      end

      private

      def check_secret_key
        raise ERROR_MESSAGE unless Constants::Shared::HMAC_SECRET
      end
    end
  end
end
