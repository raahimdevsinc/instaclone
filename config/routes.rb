# frozen_string_literal: true

Rails.application.routes.draw do
  get 'profiles/index'
  resources :likes, only: %i[create destroy]
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/users' => 'devise/registrations#new'
    get 'users/password' => 'devise/passwords#new'
  end
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, only: [:show]

  post 'users/:id/follow' => 'users#follow', as: 'follow'
  post 'users/:id/unfollow' => 'users#unfollow', as: 'unfollow'
  post 'users/:id/accept' => 'users#accept', as: 'accept'
  post 'users/:id/decline' => 'users#decline', as: 'decline'
  post 'users/:id/cancel' => 'users#cancel', as: 'cancel'

  get 'home/about'
  get 'posts/myposts'

  resources :posts do
    resources :comments, only: %i[index create destroy]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'posts#index'
end
