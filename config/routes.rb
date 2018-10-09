Rails.application.routes.draw do

  get 'sessions/new'

  root "static_pages#home"
  get "/about", to: "static_pages#about"
  get "/help", to: "static_pages#help"
  get "/contact", to: "static_pages#contact"
  get "/agreement", to: "static_pages#agreement"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users do
    member do
      get :following, :followers, :favorites, :change_password, :more_favorites, :more_microposts
    end
  end

  get "/login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get 'password_resets/new'
  get 'password_resets/edit'
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :microposts do
    member do
      post :favorite
    end
  end

  resources :comments, only: :create
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :notifications, only: :index

  get '/auth/:provider/callback', to: 'users#facebook_login', as: :auth_callback

end
