# frozen_string_literal: true

module Api::V1::Users
  class RegistrationsController < ApiController
    def create
      endpoint operation: Api::V1::Users::Registrations::Operation::Create
    end
  end
end
