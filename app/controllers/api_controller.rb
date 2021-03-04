# frozen_string_literal: true

class ApiController < ActionController::API
  include Authentication
  include SimpleEndpoint::Controller
  include DefaultEndpoint

  def endpoint_options
    { params: params.to_unsafe_h }
  end
end
