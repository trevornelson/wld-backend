class AuthenticationController < ApplicationController
	skip_before_action :authenticate_request!, raise: false

	def authenticate
		command = AuthenticateUser.call(params[:email], params[:password])

		if command.success?
			user = User.find_by_email(params[:email])
			render json: { auth_token: command.result, user: user }
		else
			render json: { error: command.errors }, status: :unauthorized
		end
	end

  def validate_token
    command = ValidateToken.call(params[:token])
    
    if command.success?
      render json: { auth_token: params[:token], user: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

end
