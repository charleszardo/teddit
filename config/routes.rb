Rails.application.routes.draw do
  root 'subs#index'

  resources :users, only: [:index, :new, :create]

  resource :session, only: [:new, :create, :destroy]

  resources :subs
end
