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

  def update
    if @user
      @user.update_attributes(user_params)
      json_response(@user, :ok)
    else
      json_response(@user, :bad_request)
    end
  end

  def presigned_url
    url = s3_bucket.presigned_post(
            key: @user.s3_bucket_key,
            success_action_status: '201',
            acl: 'public-read'
          )

    if url
      json_response({ signed_s3_url: url }, :ok)
    else
      json_response({ message: 'Could not fetch presigned s3 url.' }, :service_unavailable)
    end

  end

	private

  def s3_bucket
    S3_BUCKET
  end

	def user_params
		params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :purpose)
	end

end
