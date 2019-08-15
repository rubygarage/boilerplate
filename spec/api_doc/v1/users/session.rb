# frozen_string_literal: true

module ApiDoc
  module V1
    module Users
      module Session
        extend ::Dox::DSL::Syntax

        document :api do
          resource 'Sessions' do
            endpoint '/users/session'
            group 'Session'
          end
        end

        document :create do
          action 'Create user session (Sign In)'
        end

        document :destroy do
          action 'Destroy user session (Sign Out)'
        end
      end
    end
  end
end
