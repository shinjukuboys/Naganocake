Rails.application.routes.draw do
# 顧客用
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords,], controllers: {
  registrations: "customer/registrations",
  sessions: 'customer/sessions'
}
# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
  scope module: :customer do
    resources:addresses, only: [:index, :create, :destroy, :edit, :update]
    resources:orders, only: [:index, :new, :create, :show]
    post 'orders/check' => "orders#check"
    get 'orders/thanks' => "orders#thanks"
    resources:cart_items, only: [:index, :create, :destroy, :update]
    delete 'cart_items/destroy_all' => "cart_items#destory_all"
    resources:items, only: [:index, :show]
    resources:customers, only: [:show, :edit, :update]do
      collection do
        get :quit
        patch :out
      end
    end
    get 'homes/top' => "homes#top"
    get 'homes/about' => "homes#about"
    root to: 'homes#top'
  end
  namespace :admin do
    root "orders#index"
    resources:orders, only: [:index, :show, :update]
    put 'order_details/update' => "order_details#update"
    resources:genres, only: [:index, :create, :edit, :update]
    resources:items, only: [:index, :new, :show, :create, :edit, :update]
    resources:customers, only: [:index, :show, :edit, :update]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end