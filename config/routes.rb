Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root to: "home#index"

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
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
  resources :photos, only: [:new, :create]
  resources :searches, only: [:show]
  resources :payments, only: [:new, :create]
  resources :reservations, only: [:show]
  resources :kennel_ratings, only: [:new, :create]
  resources :stand_by_reservations, only: [:new, :create]
  resources :blogs
  resources :pawbookings_admins, only: [:index]
  resources :check_in_check_out_reservations, only: [:update]

  # KennelsController
  resources :kennels, only: [:new, :create]
    get "/kennel_dashboard",   to: "kennels#kennel_dashboard",   as: :kennel_dashboard
    get "/kennel_reservations", to: "kennels#kennel_reservations", as: :kennel_reservations
    get "/kennel_searched_reservation", to: "kennels#kennel_searched_reservation", as: :kennel_searched_reservation

  # CustomersController
    get "/customer_dashboard", to: "customers#customer_dashboard", as: :customer_dashboard

  # SearchesController
    get "/search_results", to: "searches#search_results", as: :search_results

  # BlogsController
    get '/blog_search', to: "blogs#blog_search", as: :blog_search

end
