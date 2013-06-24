MapVotes::Application.routes.draw do
  root to: "home#index"

  match "/auth/steam/callback" => "sessions#create"

  resources :elections
  resources :maps
end
