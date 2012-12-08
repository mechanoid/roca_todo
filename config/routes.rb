RocaTodo::Application.routes.draw do
  root to: 'todos#index'
  resources :todos, only: [:index, :show, :create, :update, :destroy] do
    collection do
      filters = [:active, :completed]
      filters.each do |f|
        resources f, only: [:index], controller: :todos, filter: f.to_s, as: "#{f}_todos"
      end
    end
  end
end
