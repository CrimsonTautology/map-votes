MapVotes::Application.routes.draw do
  get "home/index"

  root to: "home#index"

  match "/auth/steam/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", as: :signout

  resources :elections
  resources :maps
end
