Rails.application.routes.draw do
  
  resources :users do
    resources :trailheads
  end

  resources :trailheads do
    collection do
      post "email"
      get "map"
    end
  end

  root :to => "home#index"
  end
