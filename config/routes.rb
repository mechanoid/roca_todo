RocaTodo::Application.routes.draw do
  root to: 'todos#index'
  resources :todos, only: [:index, :show, :create, :update, :destroy] do
    collection do
      resources :active, only: [:index], controller: :todos, filter: 'active', as: "active_todos"
      resources :completed, only: [:index], controller: :todos, filter: 'completed', as: "completed_todos"
      delete 'completed' => 'todos#delete_completed', as: :delete_completed
    end
  end
end
