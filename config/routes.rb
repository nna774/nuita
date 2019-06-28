Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  get 'pages/home'
  get '/i/likes', :to => 'pages#favorites', as: 'likes'
  get '/i/notifications', :to=> 'pages#notifications', as: 'notifications'
  get 'pages/about'
  get '/auth/twitter/callback', :to => 'twitters#create'
  post '/auth/twitter/callback', :to => 'twitters#create'
  delete '/auth/twitter', :to => 'twitters#destroy'

  resources :users, except: [:index], param: :url_digest
  resources :nweets, only: [:create, :update, :destroy, :show], param: :url_digest
  resource :favorite, only: [:create, :destroy]
end
