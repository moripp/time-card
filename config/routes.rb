Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  root "times#index"
  resources :home, only: [:index]
  resources :times, only: [:index, :create]
end
