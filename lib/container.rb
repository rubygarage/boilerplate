# frozen_string_literal: true

class Container
  extend Dry::Container::Mixin

  namespace 'adapters' do
    register('redis') { Api::V1::Users::Lib::Service::RedisAdapter }
  end

  namespace 'services' do
    register('pagy') { Service::Pagy }
    register('email_token') { Api::V1::Users::Lib::Service::EmailToken }
    register('session_token') { Api::V1::Users::Lib::Service::SessionToken }
    register('token_namespace') { Api::V1::Users::Lib::Service::TokenNamespace }
  end
end
