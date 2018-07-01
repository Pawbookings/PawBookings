Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  root to: "home#index"
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, :controllers => { registrations: "devise_registrations", passwords: "devise_passwords" }
  get "/users/sign_in" => redirect("/")

  resources :home
  resources :contact_messages, only: [:new, :create]
  resources :customer_emergency_contacts, only: [:new, :create, :update, :destroy]
  resources :customer_vet_infos, only: [:new, :create, :update, :destroy]
  resources :hours_of_operations, only: [:edit, :update, :create, :destroy]
  resources :holidays
  resources :breed_restrictions
  resources :pets, only: [:new, :create, :update, :destroy]
  resources :amenities, only: [:new, :create, :update, :destroy]
  resources :policies, only: [:new, :create, :update, :destroy]
  resources :photos
  get '/reservations/old', to: "reservations#old_reservations", as: :old_reservation
  get '/get_pets', to: "reservations#get_pets", as: :get_pets


  post '/save_old_reservation', to: "reservations#save_old_reservations", as: :save_old_reservation
  resources :reservations, only: [:show]
  resources :kennel_ratings, only: [:new, :create]
  resources :stand_by_reservations, only: [:new, :create]
  resources :check_in_check_out_reservations, only: [:update]
  resources :check_in_contract_important_informations, only: [:update, :edit]
  resources :check_in_contract_reservation_changes, only: [:update, :edit]
  resources :check_in_contract_refund_policies, only: [:update, :edit]
  resources :press_pages

  # CsvKennelsController
    resources :csv_kennels
    post '/notify_kennel', to: 'csv_kennels#notify_kennel', as: :notify_kennel
    get '/claim_business', to: 'csv_kennels#claim_business', as: :claim_business
    post '/send_business_claim', to: 'csv_kennels#send_business_claim', as: :send_business_claim


  # PawbookingsAdminsController
   resources :pawbookings_admins, only: [:index]
   get '/admin_reservation_search', to: "pawbookings_admins#admin_reservation_search", as: :admin_reservation_search

   get '/refund_reservation_select', to: "pawbookings_admins#refund_reservation_select", as: :refund_reservation_select
   get '/refund_reservation_confirm', to: "pawbookings_admins#refund_reservation_confirm", as: :refund_reservation_confirm

   get '/update_reservation', to: "pawbookings_admins#update_reservation", as: :update_reservation

  # RunsController
    resources :runs, only: [:new, :create, :update, :destroy]
    delete "/delete_run_image", to: "runs#delete_run_image", as: :delete_run_image

  # PaymentsController
    resources :payments, only: [:new, :create]
    get "/vaccination_upload_after_payment", to: "payments#vaccination_upload_after_payment", as: :vaccination_upload_after_payment

  # KennelsController
    resources :kennels, only: [:new, :create, :update, :show, :edit]
    get "/kennel_dashboard",   to: "kennels#kennel_dashboard",   as: :kennel_dashboard
    get "/kennel_reservations", to: "kennels#kennel_reservations", as: :kennel_reservations
    get "/kennel_view_pets", to: "kennels#kennel_view_pets", as: :kennel_view_pets
    match "/kennel_searched_reservation", to: "kennels#kennel_searched_reservation", as: :kennel_searched_reservation, via: [:get, :post]

  # CustomersController
    get "/customer_dashboard", to: "customers#customer_dashboard", as: :customer_dashboard
    post "/create_user_image", to: "customers#create_user_image", as: :create_user_image
    delete "/delete_user_image", to: "customers#delete_user_image", as: :delete_user_image

  # SearchesController
    resources :searches, only: [:create]
    get "/search_results", to: "searches#search_results", as: :search_results

  # BlogsController
    resources :blogs
    match "/blog_search", to: "blogs#blog_search", as: :blog_search, via: [:get, :post]
    get "/all_blogs", to: "blogs#all_blogs", as: :all_blogs

  # BlogCategoriesController
    resources :blog_categories
    get "/all_blog_categories", to: "blog_categories#all_blog_categories", as: :all_blog_categories

  # Contracts
    match "/customer_checkin_contract", to: "contracts#customer_checkin_contract", as: :customer_checkin_contract, via: [:get, :post]

  # HomeController
    get "/kennel_or_customer", to: "home#kennel_or_customer", as: :kennel_or_customer
    get "/about", to: "home#about", as: :about
    get "/faq", to: "home#faq", as: :faq
    get "/policies_and_terms", to: "home#policies_and_terms", as: :policies_and_terms
    get "/changes_cancellations_refunds", to: "home#changes_cancellations_refunds", as: :changes_cancellations_refunds
    get "/terms_of_service", to: "home#terms_of_service", as: :terms_of_service
    get "/privacy_policy", to: "home#privacy_policy", as: :privacy_policy

  # Contact
    get "/message_confirmation", to: "contact_messages#message_confirmation", as: :message_confirmation


end
