# frozen_string_literal: true

module ApiDoc
  module V1
    module Users
      module Verification
        extend ::Dox::DSL::Syntax

        document :api do
          resource 'Verifications' do
            endpoint '/users/verification'
            group 'Verification'
          end
        end

        document :show do
          action 'Verificate user account'
        end
      end
    end
  end
end
