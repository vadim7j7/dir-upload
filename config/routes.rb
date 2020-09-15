Rails.application.routes.draw do
  # Override direct uploads
  post '/rails/active_storage/direct_uploads', to: 'direct_uploads#create', as: :rails_direct_uploads_dirs

  root 'home#index'
end
