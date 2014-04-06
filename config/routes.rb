Jobrunner::Application.routes.draw do
  devise_for :users
  root to: redirect("/contacts")

  resources :contacts do
    resources :users
    member do
      get :edit_section
      patch :update_section
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
end