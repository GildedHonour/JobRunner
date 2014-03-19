Jobrunner::Application.routes.draw do
  devise_for :users
  root to: redirect("/contacts")

  resources :contacts do
    resources :users
    member do
      get :edit_communications
      patch :update_communications
    end
  end

  resources :companies do
    resources :contacts
    member do
      get :edit_affiliations
      patch :update_affiliations

      get :edit_internal_company_relationships
      patch :update_internal_company_relationships

      patch :delete_company_logo
    end
  end
  resources :notes
end