# frozen_string_literal: true

Rails.application.routes.draw do
  get 'errors/not_found'
  get 'profiles/index'

  resources :likes, only: %i[create destroy]
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/users' => 'devise/registrations#new'
    get 'users/password' => 'devise/passwords#new'
  end
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    defaults: { format: :json }
  }

  resources :users, only: [:show]

  post 'users/:id/follow' => 'users#follow', as: 'user_follow'
  get 'users/:id/following', to: 'users#following', as: 'user_following'
  get 'users/:id/followers', to: 'users#followers', as: 'user_followers'
  post 'users/:id/unfollow' => 'users#unfollow', as: 'unfollow'
  post 'users/:id/accept' => 'users#accept', as: 'accept'
  post 'users/:id/decline' => 'users#decline', as: 'decline'
  post 'users/:id/cancel' => 'users#cancel', as: 'cancel'
  post '/users/sign_in', to: 'users/sessions#create'
  get '/users/current_user', to: 'users#current_user'

  get 'home/about'
  get 'posts/myposts'

  resources :posts do
    resources :comments, only: %i[index create]
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'posts#index'

  # Catch-all route for handling 404 errors
  match '*path', to: 'errors#not_found', via: :all
end
