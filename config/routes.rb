Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "prompts#index"

  devise_for :users, skip: [:sessions, :registrations]
  devise_scope :user do
    get "sign_up", to: "users#new", as: :sign_up
    post "sign_up", to: "users#create"
    get "login", to: "sessions#new", as: :login
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :logout
  end

  resources :users, only: [:show, :edit, :update]
  resources :prompts do
    resources :reviews, except: :show
  end

  namespace :api do
    namespace :v1 do
      post "auth/login", to: "sessions#create"
      delete "auth/logout", to: "sessions#destroy"
      resources :users, only: [:show]
      resources :prompts do
        resources :prompt_versions, only: [:index, :show, :create]
        resources :reviews, only: [:index, :create, :update, :destroy]
      end
    end
  end
end
