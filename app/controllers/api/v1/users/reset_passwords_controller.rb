# frozen_string_literal: true

module Api::V1::Users
  class ResetPasswordsController < ApiController
    def create
      endpoint operation: Api::V1::Users::ResetPasswords::Operation::Create
    end

    def show
      endpoint operation: Api::V1::Users::ResetPasswords::Operation::Show
    end

    def update
      endpoint operation: Api::V1::Users::ResetPasswords::Operation::Update
    end
  end
end
