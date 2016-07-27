Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root to: "home#index"

  devise_for :users, :controllers => { registrations: 'devise_registrations', passwords: "devise_passwords" }
  get "/users/sign_in" => redirect("/")

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
  resources :payments, only: [:new, :create]
  resources :reservations, only: [:show]

  # KennelsController
  resources :kennels, only: [:new, :create]
    get "/kennel_dashboard",   to: "kennels#kennel_dashboard",   as: :kennel_dashboard
    get "/kennel_reservations", to: "kennels#kennel_reservations", as: :kennel_reservations
    get "/kennel_reservation_pet_owner_info", to: "kennels#kennel_reservation_pet_owner_info", as: :kennel_reservation_pet_owner_info
    get "/my_kennel_info", to: "kennels#my_kennel_info", as: :my_kennel_info

  # CustomersController
    get "/customer_dashboard", to: "customers#customer_dashboard", as: :customer_dashboard

  # SearchesController
    get "/search_results", to: "searches#search_results", as: :search_results

end
