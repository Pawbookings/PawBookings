Rails.application.routes.draw do

  root to: "home#index"
  get "/users/sign_in" => redirect("/")
  devise_for :users, :controllers => { registrations: 'devise_registrations', passwords: "devise_passwords" }
  resources :home
  resources :customer_emergency_contacts, only: [:new, :create]
  resources :pets, only: [:new, :create]
  resources :hours_of_operations, only: [:new, :create]
  resources :holidays, only: [:new, :create]
  resources :runs, only: [:new, :create]
  resources :amenities, only: [:new, :create]
  resources :policies, only: [:new, :create]
  resources :drop_off_pick_ups, only: [:new, :create]
  resources :photos, only: [:new, :create]
  resources :searches, only: [:show]
  resources :payments, only: [:new]

  # KennelsController
  resources :kennels, only: [:new, :create]
    get "/kennel_dashboard",   to: "kennels#kennel_dashboard",   as: :kennel_dashboard
    get "/my_kennel_info", to: "kennels#my_kennel_info", as: :my_kennel_info

  # CustomersController
    get "/customer_dashboard", to: "customers#customer_dashboard", as: :customer_dashboard

  # SearchesController
    get "/search_results", to: "searches#search_results", as: :search_results

end
