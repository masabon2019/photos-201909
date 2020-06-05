# == Route Map
#
#                    Prefix Verb   URI Pattern                                                                              Controller#Action
#                      root GET    /                                                                                        toppages#index
#                     login GET    /login(.:format)                                                                         sessions#new
#                           POST   /login(.:format)                                                                         sessions#create
#                    logout DELETE /logout(.:format)                                                                        sessions#destroy
#                    signup GET    /signup(.:format)                                                                        users#new
#           followings_user GET    /users/:id/followings(.:format)                                                          users#followings
#            followers_user GET    /users/:id/followers(.:format)                                                           users#followers
#         bookmarkings_user GET    /users/:id/bookmarkings(.:format)                                                        users#bookmarkings
#                     users GET    /users(.:format)                                                                         users#index
#                           POST   /users(.:format)                                                                         users#create
#                  new_user GET    /users/new(.:format)                                                                     users#new
#                 edit_user GET    /users/:id/edit(.:format)                                                                users#edit
#                      user GET    /users/:id(.:format)                                                                     users#show
#                           PATCH  /users/:id(.:format)                                                                     users#update
#                           PUT    /users/:id(.:format)                                                                     users#update
#                           DELETE /users/:id(.:format)                                                                     users#destroy
#                    photos GET    /photos(.:format)                                                                        photos#index
#                           POST   /photos(.:format)                                                                        photos#create
#                 new_photo GET    /photos/new(.:format)                                                                    photos#new
#                edit_photo GET    /photos/:id/edit(.:format)                                                               photos#edit
#                     photo GET    /photos/:id(.:format)                                                                    photos#show
#                           PATCH  /photos/:id(.:format)                                                                    photos#update
#                           PUT    /photos/:id(.:format)                                                                    photos#update
#                           DELETE /photos/:id(.:format)                                                                    photos#destroy
#             relationships POST   /relationships(.:format)                                                                 relationships#create
#              relationship DELETE /relationships/:id(.:format)                                                             relationships#destroy
#                 bookmarks POST   /bookmarks(.:format)                                                                     bookmarks#create
#                  bookmark DELETE /bookmarks/:id(.:format)                                                                 bookmarks#destroy
#                     goods POST   /goods(.:format)                                                                         goods#create
#                      good DELETE /goods/:id(.:format)                                                                     goods#destroy
#             guestsessions POST   /guestsessions(.:format)                                                                 guestsessions#create
#        rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

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

  #resources :photos, only: [:create, :destroy]
  resources :photos

  resources :relationships, only: [:create, :destroy]
  resources :bookmarks, only: [:create, :destroy]
  resources :goods, only: [:create, :destroy]

  resources :guestsessions, only: :create

end
