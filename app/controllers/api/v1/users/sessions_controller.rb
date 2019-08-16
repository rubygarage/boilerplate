# frozen_string_literal: true

module Api::V1::Users
  class SessionsController < ApiController
    def create
      endpoint Api::V1::Users::Sessions::Operation::Create
    end
  end
end
