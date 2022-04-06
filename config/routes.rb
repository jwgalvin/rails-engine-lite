Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get '/items/find_all', to: 'searches#find_all_items'
      get '/items/find', to: 'searches#find_item'
      get '/merchants/find_all', to: 'searches#find_all_merchants'
      get '/merchants/find', to: 'searches#find_merchant'

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
        get :most_items, on: :collection, controller: :merchants
      end
      namespace :revenue do
        resources :merchants, only: [:index, :show]
        #resources :items, only: [:index]
      end
      resources :items do
        resources :merchant, only: [:index], controller: :item_merchants
      end
    end
  end
end
