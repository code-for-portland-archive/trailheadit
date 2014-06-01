Rails.application.routes.draw do
  resources :trailheads do
    member do
      get "email"
    end
  end

  resources :phones

  root :to => "home#index"
end
