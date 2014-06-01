Rails.application.routes.draw do
  resources :trailheads

  root :to => "home#index"
end
