# frozen_string_literal: true

module Api::V1::Users::Lib::Service::SessionToken
  class << self
    def create(account_id:, namespace: nil)
      options =
        namespace ? { namespace: Api::V1::Users::Lib::Service::TokenNamespace.call(namespace, account_id) } : {}
      JWTSessions::Session.new(
        payload: { account_id: account_id, **options },
        refresh_payload: { account_id: account_id, **options }
      ).login
    end

    def destroy(refresh_token:)
      JWTSessions::Session.new.flush_by_token(refresh_token)
    end

    def destroy_all(namespace:)
      JWTSessions::Session.new(namespace: namespace).flush_namespaced
    end

    def refresh(payload:, refresh_token:)
      session = JWTSessions::Session.new(payload: payload)
      session.refresh(refresh_token) do
        session.flush_by_token(refresh_token)
        return false
      end
    end
  end
end
