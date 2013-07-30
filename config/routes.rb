MapVotes::Application.routes.draw do
  get "api_key/index"

  get "api_key/create"

  get "api_key/destroy"

  resources :maps do
    post 'vote', on: :member
    resources :map_comments 
  end
  root to: "home#index"

  match "/auth/steam/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", as: :signout
end
