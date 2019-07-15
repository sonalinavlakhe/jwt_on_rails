Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	resources :users, only: [:create, :update, :show] do
		post 'confirm'
		post 'login'
	end
end
