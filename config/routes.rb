Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :home
  resources :kennels, only: [:new, :create]
  resources :runs, only: [:new, :create]
  resources :amenities, only: [:new, :create]
  resources :policies, only: [:new, :create]
  root to: "home#index"

  # KennelController
    get "/kennel_dashboard",   to: "kennels#kennel_dashboard",   as: :kennel_dashboard
  # CustomerController
    get "/customer_dashboard", to: "customer#customer_dashboard", as: :customer_dashboard

end
