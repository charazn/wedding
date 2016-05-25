Rails.application.routes.draw do
  root to: "home#index"

  post '/invitation_card', to: "home#send_invitation_card"
  get 'thank_you', to: "home#thank_you"

  resources :user_sessions, only: [:new, :create, :destroy]
  get 'login', to: 'user_sessions#new', as: :login
  post 'logout', to: 'user_sessions#destroy', as: :logout

  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :users, only: [:new, :create]
  resource :profile, only: [:edit, :update]

  resources :photos, except: :destroy do
    post '/single', to: "photos#create_single", on: :collection
    put :archive, on: :member, as: :delete, path: :delete

    collection do
      get '/hongkong', to: "photos#hongkong"
      get '/singapore', to: "photos#singapore"
      get '/shanghai', to: "photos#shanghai"
      get '/friends', to: "photos#friends"
      get '/my', to: "photos#my"
    end

    member do
      put :favorite, action: :upvote, as: :upvote
      put :unfavorite, action: :undo_upvote, as: :undo_upvote
    end

    resources :comments, only: [:create, :edit, :update] do
      put :archive, on: :member, as: :delete, path: :delete
    end
  end

end
