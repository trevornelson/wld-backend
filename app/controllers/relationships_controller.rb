class RelationshipsController < ApplicationController
	before_action :authenticate_request

	def index
		json_response(@user.relationships, :ok)
	end

	def create
		@relationship = @user.relationships.new(relationship_params)
		@relationship.relationship_category_id = params[:relationship_category_id]

		if @relationship.valid?
			@relationship.save
			json_response(@relationship, :created)
		else
			json_response(@relationship, :bad_request)
		end
	end

	def update
		@relationship = Relationship.find(params[:id])
		json_response({ message: 'Could not update Relationship.' }, :not_found) unless @relationship

		if @relationship.update(relationship_params)
			json_response(@relationship, :ok)
		else
			json_response({ message: 'Could not update Relationship.' }, :bad_request)
		end
	end

	def destroy
		@relationship = Relationship.find(params[:id])

		if @relationship.destroy
			json_response({}, :accepted)
		else
			json_response({ message: 'Could not delete Relationship.' }, :not_found)
		end
	end

	private

	def relationship_params
		params.permit(:content)
	end

end
