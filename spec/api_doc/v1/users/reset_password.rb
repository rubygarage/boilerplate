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
          action 'Create user account reset password token'
        end

        document :show do
          action 'Verify user account reset password token'
        end

        document :update do
          action 'Update user account password'
        end
      end
    end
  end
end
