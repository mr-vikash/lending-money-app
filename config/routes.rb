require "sidekiq/web"
Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  devise_for :admins

  namespace :user do
    resources :loans, only: [:index, :show, :new, :create, :update]
  end


  namespace :admin do
    resources :loans, only: [:index, :show, :update]
  end

end
