class RelationshipCategoriesController < ApplicationController
	before_action :authenticate_request

	def index
		json_response(@user.relationship_categories, :ok)
	end

	def create
		@relationship_category = @user.relationship_categories.new(relationship_category_params)

		if @relationship_category.valid?
			@relationship_category.save
			json_response(@relationship_category, :created)
		else
			json_response(@relationship_category, :bad_request)
		end
	end

	def update
		@relationship_category = RelationshipCategory.find(params[:id])
		json_response({ message: 'Could not update Relationship Category.' }, :not_found) unless @relationship_category

		if @relationship_category.update(relationship_category_params)
			json_response(@relationship_category, :ok)
		else
			json_response({ message: 'Could not update Relationship Category.' }, :bad_request)
		end
	end

	def destroy
		@relationship_category = RelationshipCategory.find(params[:id])

		if @relationship_category.destroy
			json_response({}, :accepted)
		else
			json_response({ message: 'Could not delete Relationship Category.' }, :not_found)
		end
	end

	private

	def relationship_category_params
		params.permit(:title)
	end
end
