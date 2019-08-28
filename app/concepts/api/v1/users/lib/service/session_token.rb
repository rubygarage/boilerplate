# frozen_string_literal: true

module Api::V1::Users::Lib::Service::SessionToken
  module Create
    def self.call(account_id:, namespace: nil)
      options =
        namespace ? { namespace: Api::V1::Users::Lib::Service::TokenNamespace.call(namespace, account_id) } : {}
      JWTSessions::Session.new(payload: { account_id: account_id, **options }).login
    end
  end

  module Destroy
    def self.call(refresh_token:)
      JWTSessions::Session.new.flush_by_token(refresh_token)
    end
  end

  module DestroyAll
    def self.call(namespace:)
      JWTSessions::Session.new(namespace: namespace).flush_namespaced
    end
  end

  module Refresh
    def self.call(payload:, refresh_token:)
      session = JWTSessions::Session.new(payload: payload)
      session.refresh(refresh_token) do
        session.flush_by_token(refresh_token)
        return false
      end
    end
  end
end
