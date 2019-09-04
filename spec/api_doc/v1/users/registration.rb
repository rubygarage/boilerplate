# frozen_string_literal: true

module ApiDoc
  module V1
    module Users
      module Registration
        extend ::Dox::DSL::Syntax

        document :api do
          resource 'Registrations' do
            endpoint '/users/registration'
            group 'Registration'
          end
        end

        document :create do
          action 'Create user account (Sign Up)' do
            params(
              email: {
                type: :string,
                required: :required,
                value: FFaker::Internet.email,
                description: 'Email for user account'
              },
              password: {
                type: :string,
                required: :required,
                value: 'password',
                description: 'Password for user account'
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
