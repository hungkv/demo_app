Rails.application.routes.draw do
  get 'subcriptions/upgrade'
  post "/subcriptions/upgrade" => 'subcriptions#update'
  get 'subcriptions/unionpay_start' => 'subcriptions#unionpay_start'
  post "/subcriptions/unionpay_success" => 'subcriptions#unionpay_success'
  resources :plans
  root 'home#index'

  #devise_for :users
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
