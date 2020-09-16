Rails.application.routes.draw do
  # Override direct uploads
  post '/rails/active_storage/direct_uploads', to: 'direct_uploads#create', as: :rails_direct_uploads_dirs
  put '/rails/active_storage/disk/:encoded_token', to: 'disk#update', as: :update_rails_disk_service_dirs

  namespace :api, defaults: { format: :json } do
    resources :directories, only: :index
  end

  root 'home#index'
end
