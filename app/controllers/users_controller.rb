class UsersController < ApplicationController

	def create
		@user = User.new(user_params)
		if @user.valid?
			@user.save()
			json_response(@user, :created)
		else
			json_response(@user, :bad_request)
		end
	end

	private

	def user_params
		params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :purpose)
	end

end
