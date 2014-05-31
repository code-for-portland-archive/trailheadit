Rails.application.routes.draw do
  resources :trailheads

  resources :phones

  root :to => "home#index"
end
