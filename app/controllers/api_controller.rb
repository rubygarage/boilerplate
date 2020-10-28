# frozen_string_literal: true

class ApiController < ActionController::API
  include DefaultEndpoint
  include Authentication
end
