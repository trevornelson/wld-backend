class ApplicationController < ActionController::API
	attr_reader :current_user, :user

	include Response
	include ExceptionHandler

	private

	def authenticate_request
		@current_user = AuthorizeApiRequest.call(request.headers).result
		render json: { error: 'Not Authorized' }, status: 401 unless user_is_authorized 
	end

	def user_is_authorized
		if set_user
			@current_user && @user.id == @current_user.id
		else
			@current_user
		end
	end

	def set_user
		@user = User.find(params[:user_id])
	end

end
