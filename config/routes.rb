Jobrunner::Application.routes.draw do
  devise_for :users
  root to: "contacts#index"
  resources :contacts
  resources :companies do
    get :edit_affiliations
    patch :update_affiliations
  end
end