Rails.application.routes.draw do
  devise_for :users
  root to: 'application#angular'

  resources :users

  resources :subs, only: [:index, :show, :create]
end
