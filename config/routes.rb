Rails.application.routes.draw do

  resources :users do
    resources :trailheads
  end

  resources :trailheads do
    collection do
      post "email"
      get "map"
      get "fusion"
      get "wall"
    end
  end

  root :to => "home#index"

  get "bootleg", to: "home#bootleg"

  match "/dj" => DelayedJobWeb, :anchor => false, via: [:get, :post]
end

