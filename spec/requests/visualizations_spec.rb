require 'rails_helper'

RSpec.describe 'Visualizations API', type: :request do

	describe 'GET /users/:user_id/visualizations' do
		let (:user) { create(:user) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				get "/users/#{user.id}/visualizations", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				get "/users/#{user.id}/visualizations", params: {}, headers: headers
			end

			it 'should return a 200 status' do
				expect(response).to have_http_status(:ok)
			end
		end

	end

	describe 'POST /users/:user_id/visualizations' do
		let (:user) { create(:user) }
		let (:other_user) { create(:user) }
		let (:valid_attributes) { attributes_for(:visualization) }

		context 'when the request is for another user' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				post "/users/#{other_user.id}/visualizations", params: valid_attributes, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				post "/users/#{user.id}/values", params: valid_attributes, headers: headers
			end

			it 'should return a created status' do
				expect(response).to have_http_status(:created)
			end

			it 'should return the created visualization' do
				expect(json['id']).to be_truthy
			end

		end
	end

	describe 'PUT /users/:user_id/visualizations/:visualization_id' do
		let (:user) { create(:user) }
		let (:visualization) { create(:visualization, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				put "/users/#{user.id}/visualizations/#{visualization.id}", params: { caption: 'new caption' }, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				put "/users/#{user.id}/visualizations/#{visualization.id}", params: { caption: 'new caption' }, headers: headers
			end

			it 'should return a 200 code' do
				expect(response).to have_http_status(:ok)
			end

			it 'should return the updated visualization' do
				expect(json['id']).to eq(visualization.id)
				expect(json['caption']).to eq('new caption')
			end
		end
	end

	describe 'DELETE /users/:user_id/visualizations/:visualization_id' do
		let (:user) { create(:user) }
		let (:visualization) { create(:visualization, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				delete "/users/#{user.id}/visualizations/#{visualization.id}", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				delete "/users/#{user.id}/visualizations/#{visualization.id}", params: {}, headers: headers
			end

			it 'should return a 202 code' do
				expect(response).to have_http_status(:accepted)
			end
		end
	end

end
