MapVotes::Application.routes.draw do
  resources :api_keys

  resources :maps do
    post 'vote', on: :member
    resources :map_comments 
  end
  root to: "home#index"

  match "/auth/steam/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", as: :signout
end
