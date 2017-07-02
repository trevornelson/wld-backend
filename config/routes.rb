Rails.application.routes.draw do
	post 'authenticate', to: 'authentication#authenticate'
  post 'validate_token', to: 'authentication#validate_token'

	resources :users, only: [:show, :create, :update] do
		resources :values, :only => [:index, :create, :update, :destroy]
		resources :long_term_goals, :only => [:index, :create, :update, :destroy]
		resources :short_term_goals, :only => [:index, :create, :update, :destroy]
		resources :quarterly_todos, :only => [:index, :create, :update, :destroy]
		resources :daily_todos, :only => [:index, :create, :update, :destroy]
    resources :habits, :only => [:create, :update, :destroy]
    resources :habit_todos, :only => [:create, :destroy]
		resources :relationship_categories, :only => [:index, :create, :update, :destroy] do
			resources :relationships, :only => [:index, :create, :update, :destroy]
		end
	end

  get 'users/:user_id/daily_todos/prev/:number_of_weeks', to: 'daily_todos#prev'
  get 'users/:user_id/daily_todos/next/:number_of_weeks', to: 'daily_todos#next'
end
