Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: :create do
  	post 'confirm'
  	post 'login'
  	put 'update'
  	get 'show'
  end
end
