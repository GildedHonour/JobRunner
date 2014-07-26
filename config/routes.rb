Jobrunner::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root to: redirect("/contacts")

  resources :activities
  resources :notes
  resources :contacts do
    collection do
      get "get_addresses/:company_id" => "contacts#get_addresses", as: :get_addresses
    end

    member do
      get :edit_section
      patch :update_section
      get :new_invite
      post :re_invite
      post :invite
    end
  end

  resources :companies do
    member do
      get :edit_section
      patch :update_section
      patch :delete_company_logo
    end

    resources :contacts
  end
  
  namespace "api" do
    resources :company_types, defaults: { format: "json" }
    resources :companies, defaults: { format: "json" } do
      resources :contacts
    end
    resources :sessions, defaults: { format: "json" }
  end
end
