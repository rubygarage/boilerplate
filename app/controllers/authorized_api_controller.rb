# frozen_string_literal: true

class AuthorizedApiController < ApiController
  before_action :authorize_access_request!

  private

  def operation_options(options)
    { current_account: current_account, **options }
  end
end
