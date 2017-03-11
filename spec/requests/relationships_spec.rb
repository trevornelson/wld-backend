require 'rails_helper'

RSpec.describe 'Relationships API', type: :request do
	describe 'GET /users/:user_id/relationship_categories/:category_id/relationships' do
		let (:user) { create(:user) }
		let (:category) { create(:relationship_category, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				get "/users/#{user.id}/relationship_categories/#{category.id}/relationships", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				get "/users/#{user.id}/relationship_categories/#{category.id}/relationships", params: {}, headers: headers
			end

			it 'should return a 200 status' do
				expect(response).to have_http_status(:ok)
			end
		end

	end

	describe 'POST /users/:user_id/relationship_categories/:category_id/relationships' do
		let (:user) { create(:user) }
		let (:category) { create(:relationship_category, { user_id: user.id }) }
		let (:valid_attributes) { attributes_for(:relationship) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				post "/users/#{user.id}/relationship_categories/#{category.id}/relationships", params: valid_attributes, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				post "/users/#{user.id}/relationship_categories/#{category.id}/relationships", params: valid_attributes, headers: headers
			end

			it 'should return a created status' do
				expect(response).to have_http_status(:created)
			end

			it 'should return the created Relationship' do
				expect(json['id']).to be_truthy
				expect(json['relationship_category_id']).to eq(category.id)
			end
		end
	end

	describe 'PUT /users/:user_id/relationship_categories/:category_id/relationships/:id' do
		let (:user) { create(:user) }
		let (:category) { create(:relationship_category, { user_id: user.id }) }
		let (:relationship) { create(:relationship, { user_id: user.id, relationship_category_id: category.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				put "/users/#{user.id}/relationship_categories/#{category.id}/relationships/#{relationship.id}", params: { content: 'new content' }, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				put "/users/#{user.id}/relationship_categories/#{category.id}/relationships/#{relationship.id}", params: { content: 'new content' }, headers: headers
			end

			it 'should return a 200 code' do
				expect(response).to have_http_status(:ok)
			end

			it 'should return the updated Relationship' do
				expect(json['id']).to eq(relationship.id)
				expect(json['content']).to eq('new content')
			end
		end
	end

	describe 'DELETE /users/:user_id/relationship_categories/:category_id/relationships/:id' do
		let (:user) { create(:user) }
		let (:category) { create(:relationship_category, { user_id: user.id }) }
		let (:relationship) { create(:relationship, { user_id: user.id, relationship_category_id: category.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				delete "/users/#{user.id}/relationship_categories/#{category.id}/relationships/#{relationship.id}", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				delete "/users/#{user.id}/relationship_categories/#{category.id}/relationships/#{relationship.id}", params: {}, headers: headers
			end

			it 'should return a 202 code' do
				expect(response).to have_http_status(:accepted)
			end
		end
	end

end
