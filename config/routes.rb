Rails.application.routes.draw do
  root "times#index"
  resources :times, only: [:index]
end
