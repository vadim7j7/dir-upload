Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :directories, only: :index do
      post :archive, on: :collection
    end
    post :direct_uploads, to: 'direct_uploads#create', as: :direct_uploads
  end

  root 'home#index'
end
