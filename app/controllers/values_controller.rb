class ValuesController < ApplicationController
	before_action :authenticate_request

	def index
		json_response(@user.values, :ok)
	end

	def create
		@value = @user.values.new(value_params)

		if @value.valid?
			@value.save
			json_response(@value, :created)
		else
			json_response(@value, :bad_request)
		end
	end

	def update
		@value = Value.find(params[:id])
		json_response({ message: 'Could not update Core Value.' }, :not_found) unless @value

		if @value.update(value_params)
			json_response(@value, :ok)
		else
			json_response({ message: 'Could not update Core Value.' }, :bad_request)
		end
	end

	def destroy
		@value = Value.find(params[:id])

		if @value.destroy
			json_response({}, :accepted)
		else
			json_response({ message: 'Could not delete Core Value' }, :not_found)
		end
	end

	private

	def value_params
		params.permit(:content)
	end

end
