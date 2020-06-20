Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users do
    member do
      get :followings
      get :followers
      get :bookmarkings
    end
  end

  resources :photos

  resources :relationships, only: [:create, :destroy]
  resources :bookmarks, only: [:create, :destroy]
  resources :goods, only: [:create, :destroy]
  resources :usercomments, only: [:create, :destroy]

  resources :guestsessions, only: :create

end
