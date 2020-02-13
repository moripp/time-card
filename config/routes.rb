Rails.application.routes.draw do
  devise_for :users
  root "times#index"
  resources :times, only: [:index]
end
