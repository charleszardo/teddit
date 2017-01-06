Rails.application.routes.draw do
  root 'subs#index'

  resources :users, only: [:show, :index, :new, :create]

  resource :session, only: [:new, :create, :destroy]

  resources :subs do
    resources :posts, only: [:new, :create]
    resources :subscriptions, only: [:create]
  end

  resources :subscriptions, only: [:destroy]

  resources :posts, only: [:show, :edit, :update, :destroy] do
    resources :comments, only: [:new]
    member do
      post :upvote
      post :downvote
    end
  end

  resources :comments, only: [:create, :show] do
    member do
      post :upvote
      post :downvote
    end
  end
end
