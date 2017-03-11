class ShortTermGoalsController < ApplicationController
	before_action :authenticate_request

	def index
		json_response(@user.short_term_goals, :ok)
	end

	def create
		@short_term_goal = @user.short_term_goals.new(short_term_goal_params)

		if @short_term_goal.valid?
			@short_term_goal.save
			json_response(@short_term_goal, :created)
		else
			json_response(@short_term_goal, :bad_request)
		end
	end

	def update
		@short_term_goal = ShortTermGoal.find(params[:id])
		json_response({ message: 'Could not update Short Term Goal.' }, :not_found) unless @short_term_goal

		if @short_term_goal.update(short_term_goal_params)
			json_response(@short_term_goal, :ok)
		else
			json_response({ message: 'Could not update Short Term Goal.' }, :bad_request)
		end
	end

	def destroy
		@short_term_goal = ShortTermGoal.find(params[:id])

		if @short_term_goal.destroy
			json_response({}, :accepted)
		else
			json_response({ message: 'Could not delete Short Term Goal.' }, :not_found)
		end
	end

	private

	def short_term_goal_params
		params.permit(:long_term_goal_id, :category, :content)
	end
end
