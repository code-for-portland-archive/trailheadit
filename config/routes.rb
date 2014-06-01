Rails.application.routes.draw do
  resources :trailheads do
    collection do
      post "email"
    end
  end

  resources :phones

  root :to => "home#index"
end
