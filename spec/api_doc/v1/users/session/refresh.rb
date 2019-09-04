# frozen_string_literal: true

module ApiDoc
  module V1
    module Users
      module Session
        module Refresh
          extend ::Dox::DSL::Syntax

          document :api do
            resource 'Session Refresh' do
              endpoint '/users/session/refresh'
              group 'Session'
            end
          end

          document :create do
            action 'Refresh user session'
          end
        end
      end
    end
  end
end
