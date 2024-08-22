Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  resources :words, only: [:index, :show, :create, :update, :destroy] do
    collection do
      get 'search'
    end

    resources :meanings, only: [:index, :show, :create, :destroy, :update], module: 'words'
    resources :examples, only: [:index, :show, :create, :destroy, :update], module: 'words'
    resources :histories, only: [:index, :show, :create, :destroy, :update], module: 'words'
  end

  # resources :examples, only: [:index, :show, :create, :update, :destroy]
end
