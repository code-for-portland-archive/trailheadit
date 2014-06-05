Rails.application.routes.draw do
  
  resources :users do
    resources :trailheads
  end

  resources :trailheads do
    collection do
      post "email"
    end
  end

  root :to => "trailheads#index"
  end
