class UsersController < ApplicationController

	def create
		@user = User.create!(user_params)
		json_response(@user, :created)
	end

	private

	def user_params
		params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :purpose)
	end

end
