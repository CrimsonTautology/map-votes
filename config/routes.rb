MapVotes::Application.routes.draw do
  get "maps/index"

  get "maps/show"

  get "maps/edit"

  get "elections/index"

  get "elections/active"

  get "elections/past"

  get "elections/show"

  get "elections/new"

  get "elections/edit"

  get "elections/delete"

  get "elections/vote"

  get "home/index"

  root to: "home#index"

  match "/auth/steam/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", as: :signout

  resources :elections
  resources :maps
end
