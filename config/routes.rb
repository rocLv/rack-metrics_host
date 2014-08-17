Rails.application.routes.draw do

  devise_scope :user do
    get 'invitation' => 'invitation#invitation', as: 'invitation'
    post 'invitation' => 'invitation#register_invitation'
  end

  get "requests/index"

  get "requests/show"

  resources :projects do
    resources :alerts
    match '/metrics' => 'projects#metrics', via: :get
    member do
      match 'page_load_last_100' => 'projects#page_load_last_100', via: :get
      match 'rpm' => 'projects#rpm', via: :get
      match 'memory' => 'projects#memory', via: :get
      match 'page_load' => 'projects#page_load', via: :get
    end
    resources :requests, only: [:index, :show] do
      collection do
        get :dashboard
        get :busiest_paths
      end
    end
    resources :users, only: [:index, :destroy]
    resources :invitations
  end
  devise_for :users, :skip => [:registrations]
    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  namespace :api do
    namespace :v1 do
      match '/' => 'projects#index', via: :post, defaults: {format: :json}
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'projects#index'

end
