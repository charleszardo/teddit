Rails.application.routes.draw do
  root 'subs#index'

  resources :users, only: [:show, :index, :new, :create]

  resource :session, only: [:new, :create, :destroy]

  resources :subs do
    resources :posts, only: [:new, :create]
  end

  resources :posts, only: [:show, :edit, :update, :destroy] do
    resources :comments, only: [:new]
  end

  resources :comments, only: [:create]
end
