MapVotes::Application.routes.draw do
  resources :maps do
    post 'create_comment', on: :member
    post 'destroy_comment', on: :member
    post 'vote', on: :member
  end
  resources :map_comments 
  resources :elections do
    get 'active', on: :collection
    get 'past', on: :collection
    get 'vote', on: :member

  end

  root to: "home#index"

  match "/auth/steam/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", as: :signout
end
