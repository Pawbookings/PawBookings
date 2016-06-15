Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users, :controllers => { registrations: 'devise_registrations' }
  resources :home
  resources :kennels, only: [:new, :create]
  resources :runs, only: [:new, :create]
  resources :amenities, only: [:new, :create]
  resources :policies, only: [:new, :create]

  # KennelController
    get "/kennel_dashboard",   to: "kennels#kennel_dashboard",   as: :kennel_dashboard
    get "/my_kennel_info", to: "kennels#my_kennel_info", as: :my_kennel_info
  # CustomerController
    get "/customer_dashboard", to: "customer#customer_dashboard", as: :customer_dashboard

end
