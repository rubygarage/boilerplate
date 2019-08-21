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
          action 'Create user account (Sign Up)'
        end
      end
    end
  end
end
