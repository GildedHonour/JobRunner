Jobrunner::Application.routes.draw do
  devise_for :users
  root to: redirect("/contacts")

  resources :contacts do
    resources :users
  end

  resources :companies do
    get :edit_affiliations
    patch :update_affiliations
  end
end