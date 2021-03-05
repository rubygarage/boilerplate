# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern
  include JWTSessions::RailsAuthorization

  included do
    rescue_from JWTSessions::Errors::Unauthorized do
      render(
        jsonapi: Service::JsonApi::HashErrorSerializer.call(base: [I18n.t('dry_validation.
                                                                           errors.
                                                                           session.
                                                                           invalid_token')]),
        status: :unauthorized
      )
    end
  end

  def current_account
    @current_account ||= Account.find_by(id: payload['account_id'])
  end
end
