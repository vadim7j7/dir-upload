Rails.application.routes.draw do
  # Override direct uploads
  post '/rails/active_storage/direct_uploads', to: 'direct_uploads#create', as: :rails_direct_uploads_dirs

  namespace :api, defaults: { format: :json } do
    resources :directories, only: :index do
      post :archive, on: :collection
    end
  end

  root 'home#index'
end
