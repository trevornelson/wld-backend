class UsersController < ApplicationController
  before_action :authenticate_request, except: [:create, :presigned_url]

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
    @user = User.find(params[:id])
    json_response({ message: 'Could not fetch presigned s3 url.' }, :not_found) unless @user

    headers = { "Content-Type" => params[:contentType], "x-amz-acl" => "public-read" }

    url = s3_storage.put_object_url(
      ENV['S3_BUCKET'],
      "#{@user.s3_bucket_key}/#{params[:objectName]}",
      15.minutes.from_now.to_time.to_i,
      headers,
    )

    if url
      json_response({ signedUrl: url }, :ok)
    else
      json_response({ message: 'Could not fetch presigned s3 url.' }, :service_unavailable)
    end

  end

	private

  def s3_storage
    S3_STORAGE
  end

	def user_params
		params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :purpose)
	end

end
