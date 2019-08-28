# frozen_string_literal: true

module Api::V1::Users::Lib::Service
  class RedisAdapter
    attr_reader :storage, :token_name

    class << self
      def push_token(token)
        new(token).push
      end

      def find_token(token)
        new(token).find
      end

      def delete_token(token)
        new(token).delete
      end
    end

    def initialize(token)
      @storage = Redis.current
      @token = token
      payload = Api::V1::Users::Lib::Service::EmailToken.read(token) || {}
      @token_name = Api::V1::Users::Lib::Service::TokenNamespace.call(payload[:namespace], payload[:account_id])
      @token_exp = payload[:exp]
    end

    def push
      storage.setex(token_name, @token_exp, @token)
    end

    def find
      storage.get(token_name)
    end

    def delete
      storage.del(token_name)
    end
  end
end
