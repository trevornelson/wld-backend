class LongTermGoalsController < ApplicationController
	before_action :authenticate_request

	def index
		json_response(@user.long_term_goals, :ok)
	end

	def create
		@long_term_goal = @user.long_term_goals.new(long_term_goal_params)

		if @long_term_goal.valid?
			@long_term_goal.save
			json_response(@long_term_goal, :created)
		else
			json_response(@long_term_goal, :bad_request)
		end
	end

	def update
		@long_term_goal = LongTermGoal.find(params[:id])
		json_response({ message: 'Could not update Long Term Goal.' }, :not_found) unless @long_term_goal

		if @long_term_goal.update(long_term_goal_params)
			json_response(@long_term_goal, :ok)
		else
			json_response({ message: 'Could not update Long Term Goal.' }, :bad_request)
		end
	end

	def destroy
		@long_term_goal = LongTermGoal.find(params[:id])

		if @long_term_goal.destroy
			json_response({}, :accepted)
		else
			json_response({ message: 'Could not delete Long Term Goal.' }, :not_found)
		end
	end

	private

	def long_term_goal_params
		params.permit(:category, :timeframe, :content)
	end
end
