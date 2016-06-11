Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :home
  root to: "home#index"
  get "/kennel_dashboard", to: "home#kennel_dashboard", as: :kennel_dashboard
  get "/customer_dashboard", to: "home#customer_dashboard", as: :customer_dashboard
end
