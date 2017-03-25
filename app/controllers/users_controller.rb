class UsersController < ApplicationController
  before_action :authenticate_request, except: [:create]

  def show
    if @user
      json_response(@user.to_dashboard, :ok)
    else
      json_response({}, :not_found)
    end
  end

	def create
		@user = User.new(user_params)
		if @user.valid?
			@user.save()
			json_response({ user: @user, values: @user.values }, :created)
		else
			json_response({ user: @user }, :bad_request)
		end
	end

	private

	def user_params
		params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :purpose)
	end

end
