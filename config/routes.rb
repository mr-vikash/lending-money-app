require "sidekiq/web"
Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  devise_for :admins

  resources :users, only: [:index, :show]

  namespace :user do
    resources :loans, only: [:index, :show, :new, :create, :update]
  end


  namespace :admin do
    resources :loans, only: [:index, :show, :update]
  end

end
