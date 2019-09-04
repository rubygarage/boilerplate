# frozen_string_literal: true

module ApiDoc
  module V1
    module Users
      module ResetPassword
        extend ::Dox::DSL::Syntax

        document :api do
          resource 'ResetPasswords' do
            endpoint '/users/reset_password'
            group 'ResetPassword'
          end
        end

        document :create do
          action 'Create user account reset password token' do
            params(
              email: {
                type: :string,
                required: :required,
                value: FFaker::Internet.email,
                description: 'Email of existing user account'
              }
            )
          end
        end

        document :show do
          action 'Verify user account reset password token' do
            params(
              email_token: {
                type: :string,
                required: :required,
                value: 'valid.jwt.token',
                description: 'Valid and existing JWT email reset password token'
              }
            )
          end
        end

        document :update do
          action 'Update user account password' do
            params(
              email_token: {
                type: :string,
                required: :required,
                value: 'valid.jwt.token',
                description: 'Valid and existing JWT email reset password token'
              },
              password: {
                type: :string,
                required: :required,
                value: 'password',
                description: 'New password for user account'
              },
              password_confirmation: {
                type: :string,
                required: :required,
                value: 'password',
                description: 'Password confirmation for user account'
              }
            )
          end
        end
      end
    end
  end
end
