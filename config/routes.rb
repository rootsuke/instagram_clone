Rails.application.routes.draw do
  root "static_pages#home"
  get "/about", to: "static_pages#about"
  get "/help", to: "static_pages#help"
  get "/contact", to: "static_pages#contact"
  get "/agreement", to: "static_pages#agreement"

  get    "/signup", to: "users#new"
  post   "/signup", to: "users#create"
  get 'sessions/new'
  get    "/login",  to: "sessions#new"
  post   "login",   to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get 'password_resets/new'
  get 'password_resets/edit'

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :comments,            only: :create
  resources :relationships,       only: [:create, :destroy]
  resources :favorites,           only: [:create, :destroy]
  resources :notifications,       only: :index

  resources :users do
    member do
      get :following, :followers, :favorites, :change_password, :more_favorites, :more_microposts
    end
  end

  resources :microposts do
    member do
      post :favorite
    end
  end
end
