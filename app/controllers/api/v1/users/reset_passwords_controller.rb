# frozen_string_literal: true

module Api::V1::Users
  class ResetPasswordsController < ApiController
    def create
      endpoint Api::V1::Users::ResetPasswords::Operation::Create
    end

    def show
      endpoint Api::V1::Users::ResetPasswords::Operation::Show
    end

    def update
      endpoint Api::V1::Users::ResetPasswords::Operation::Update
    end
  end
end
