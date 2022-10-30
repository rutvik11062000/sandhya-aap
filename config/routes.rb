require 'sidekiq/web'

Rails.application.routes.draw do
  get 'csv/receipt'
  get 'csv/bill'
  get 'csv/order'
  get 'csv/' => 'csv#index'
  resources :orders do
    # add show_invoice action to orders
    member do
      get :show_invoice
      get :show_bill
      get :create_bill
    end
    resources :receipts, only: [:index, :show, :new, :create, :destroy] 
  end
  resources :customers
  draw :madmin
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
authenticate :user, lambda { |u| u.admin? } do
  mount Sidekiq::Web => '/sidekiq'

  namespace :madmin do
    resources :impersonates do
      post :impersonate, on: :member
      post :stop_impersonating, on: :collection
    end
  end
end

  resources :notifications, only: [:index]
  resources :announcements, only: [:index]
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root to: 'orders#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
