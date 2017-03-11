Rails.application.routes.draw do
	post 'authenticate', to: 'authentication#authenticate'

	resources :users, only: :create do
		resources :values, :only => [:index, :create, :update, :destroy]
		resources :long_term_goals, :only => [:index, :create, :update, :destroy]
		resources :short_term_goals, :only => [:index, :create, :update, :destroy]
		resources :quarterly_todos, :only => [:index, :create, :update, :destroy]
		resources :daily_todos, :only => [:index, :create, :update, :destroy]
		resources :relationship_categories, :only => [:index, :create, :update, :destroy] do
			resources :relationships, :only => [:index, :create, :update, :destroy]
		end
	end
end
