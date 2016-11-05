Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  root to: "home#index"

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => { registrations: "devise_registrations", passwords: "devise_passwords" }
  get "/users/sign_in" => redirect("/")

  resources :home
  resources :contact_messages, only: [:new, :create]
  resources :customer_emergency_contacts, only: [:new, :create]
  resources :customer_vet_infos, only: [:new, :create]
  resources :pets, only: [:new, :create]
  resources :hours_of_operations, only: [:edit, :update, :create]
  resources :holidays
  resources :runs, only: [:new, :create, :update]
  resources :amenities, only: [:new, :create, :update]
  resources :policies, only: [:new, :create]
  resources :photos, only: [:new, :create]
  resources :payments, only: [:new, :create]
  resources :reservations, only: [:show]
  resources :kennel_ratings, only: [:new, :create]
  resources :stand_by_reservations, only: [:new, :create]
  resources :pawbookings_admins, only: [:index]
  resources :check_in_check_out_reservations, only: [:update]
  resources :check_in_contract_important_informations, only: [:update, :edit]
  resources :check_in_contract_reservation_changes, only: [:update, :edit]
  resources :check_in_contract_refund_policies, only: [:update, :edit]

  # KennelsController
    resources :kennels, only: [:new, :create, :update]
    get "/kennel_dashboard",   to: "kennels#kennel_dashboard",   as: :kennel_dashboard
    get "/kennel_reservations", to: "kennels#kennel_reservations", as: :kennel_reservations
    post "/kennel_searched_reservation", to: "kennels#kennel_searched_reservation", as: :kennel_searched_reservation

  # CustomersController
    get "/customer_dashboard", to: "customers#customer_dashboard", as: :customer_dashboard
    post "/create_user_image", to: "customers#create_user_image", as: :create_user_image
    delete "/delete_user_image", to: "customers#delete_user_image", as: :delete_user_image

  # SearchesController
    resources :searches, only: [:show, :create]
    get "/search_results", to: "searches#search_results", as: :search_results

  # BlogsController
    resources :blogs
    match "/blog_search", to: "blogs#blog_search", as: :blog_search, via: [:get, :post]
    get "/all_blogs", to: "blogs#all_blogs", as: :all_blogs

  # BlogCategoriesController
    resources :blog_categories
    get "/all_blog_categories", to: "blog_categories#all_blog_categories", as: :all_blog_categories

  # Contracts
    get "/customer_checkin_contract", to: "contracts#customer_checkin_contract", as: :customer_checkin_contract

  # HomeController
    get "/kennel_or_customer", to: "home#kennel_or_customer", as: :kennel_or_customer
    get "/about", to: "home#about", as: :about

  # Contact
    get "/message_confirmation", to: "contact_messages#message_confirmation", as: :message_confirmation
end
