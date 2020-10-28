# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    namespace :v1 do
      namespace :users do
        resource :registration, only: :create
        resource :verification, only: :show
        resource :session, only: %i[create destroy] do
          scope module: :session do
            resource :refresh, only: :create
          end
        end
        resource :reset_password, only: %i[create show update]
        namespace :account do
          resource :profile, only: :show
        end
      end
    end
  end
end
