# frozen_string_literal: true

class AuthorizedApiController < ApiController
  before_action :authorize_access_request!

  private

  def endpoint_options
    { current_account: current_account, params: params }
  end
end
