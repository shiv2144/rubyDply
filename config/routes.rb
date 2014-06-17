Rails.application.routes.draw do

  use_doorkeeper

  # namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      # resources :users, :only => [:index]
      devise_for :users, path: '/users', controllers: {
        registrations: 'api/v1/custom_devise/registrations'
      }
      resources :users, only: [:index, :show] do
        get 'me', on: :collection
      end
    end
  # end

  root 'root#index'

end
