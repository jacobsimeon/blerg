Rails.application.routes.draw do
  root to: "posts#index"
  resources :posts, only: %w(index show new create)
end
