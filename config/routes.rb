Jobrunner::Application.routes.draw do
  devise_for :users
  root to: "contacts#index"
  match "contact_update", to: "contacts#update", via: :patch
  resources :contacts 
  resources :companies
end