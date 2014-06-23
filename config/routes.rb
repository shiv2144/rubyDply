Rails.application.routes.draw do

  use_doorkeeper

  namespace :api, defaults: {format: 'json'}, constraints: { format: 'json'}, path: '/' do

    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      devise_for :users, path: '/users', controllers: {
        registrations: 'api/v1/custom_devise/registrations'
      }
      resources :users, only: [:index, :show] do
        get 'me', on: :collection
      end
      resources :trades, only: [:index, :show]
      resources :job_types, only: [:index, :show]
    end

  end

  root 'root#index'

end
