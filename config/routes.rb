MapVotes::Application.routes.draw do
  resources :api_keys

  resources :maps do
    post 'vote', on: :member
    post 'favorite', on: :member
    post 'unfavorite', on: :member
    resources :map_comments 
  end

  resources :users do
    post 'ban', on: :member
    post 'unban', on: :member
    resources :map_favorites 
  end
  
  namespace :v1, defaults: {format: 'json'} do
    resources :api do
      post 'cast_vote', on: :collection
      post 'write_message', on: :collection
      post 'server_query', on: :collection
      post 'favorite', on: :collection
      post 'unfavorite', on: :collection
      post 'get_favorites', on: :collection
      post 'have_not_voted', on: :collection
    end
    
  end
  root to: "home#index"

  match "/auth/steam/callback" => "sessions#create", via: [:get, :post], as: :login
  get "/logout" => "sessions#destroy", as: :logout
end
