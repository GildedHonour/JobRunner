Jobrunner::Application.routes.draw do
  devise_for :users
  root to: redirect("/contacts")

  resources :contacts do
    resources :users
    member do
      get :edit_section
      patch :update_section
      post :reinvite
    end
  end

  resources :companies do
    resources :contacts
    member do
      get :edit_section
      patch :update_section
      patch :delete_company_logo
    end
  end
  resources :notes

  namespace "api" do
    resources :company_types, defaults: { format: 'json' }
    resources :companies, defaults: { format: 'json' }
  end
end