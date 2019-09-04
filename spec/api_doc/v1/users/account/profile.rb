# frozen_string_literal: true

module ApiDoc
  module V1
    module Users
      module Account
        module Profile
          extend ::Dox::DSL::Syntax

          document :api do
            resource 'Profiles' do
              endpoint '/users/account/profile'
              group 'Profile'
            end
          end

          document :show do
            action 'Show user profile' do
              params(
                include: {
                  type: :string,
                  required: :optional,
                  value: 'account',
                  description: 'User profile inclusion'
                }
              )
            end
          end
        end
      end
    end
  end
end
