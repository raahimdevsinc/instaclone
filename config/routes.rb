# frozen_string_literal: true

Rails.application.routes.draw do
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    get '/users' => 'devise/registrations#new'
    get 'users/password' => 'devise/passwords#new'
  end
  devise_for :users

  resources :users, only: [:show]

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
