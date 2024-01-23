PpApi::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :categories, only: [:index, :show, :create, :update, :destroy]

      resources :products, only: [:index, :show, :create, :update, :destroy] do
        get 'most_sold_products', on: :collection
        get 'most_money_products', on: :collection
      end

      resources :clients, only: [:index, :show, :create, :update, :destroy]

      resources :orders, only: [:index, :show, :create, :update, :destroy]

      resources :category_items, only: [:create, :destroy]

      resources :users, only: [:show, :create, :update, :destroy] do
        get 'me', on: :collection
      end

      post '/auth/login', to: 'auth#login'
    end
  end

  # match '*unmatched_route', :to => 'application#raise_not_found!'
end
