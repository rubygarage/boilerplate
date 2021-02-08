# frozen_string_literal: true

class ApiController < ActionController::API
  include DefaultEndpoint
  include Authentication
  include SimpleEndpoint::Controller
end
