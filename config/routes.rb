Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

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
      get :following, :followers, :change_password
    end
  end

  get "/login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  get '/auth/:provider/callback', to: 'users#facebook_login', as: :auth_callback
  get '/auth/failure',            to: 'users#auth_failure'


end
