RocaTodo::Application.routes.draw do
  root to: 'todos#index'
  resources :todos, only: [:index, :show, :create, :update, :delete]
end
