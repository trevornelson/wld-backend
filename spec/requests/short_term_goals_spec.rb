require 'rails_helper'

RSpec.describe 'Short Term Goals API', type: :request do
	describe 'GET /users/:user_id/short_term_goals' do
		let (:user) { create(:user) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				get "/users/#{user.id}/short_term_goals", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				get "/users/#{user.id}/short_term_goals", params: {}, headers: headers
			end

			it 'should return a 200 status' do
				expect(response).to have_http_status(:ok)
			end
		end

	end

	describe 'POST /users/:user_id/short_term_goals' do
		let (:user) { create(:user) }
		let (:valid_attributes) { attributes_for(:short_term_goal) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				post "/users/#{user.id}/short_term_goals", params: valid_attributes, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				post "/users/#{user.id}/short_term_goals", params: valid_attributes, headers: headers
			end

			it 'should return a created status' do
				expect(response).to have_http_status(:created)
			end

			it 'should return the created Short Term Goal' do
				expect(json['id']).to be_truthy
			end
		end
	end

	describe 'PUT /users/:user_id/short_term_goals/:id' do
		let (:user) { create(:user) }
		let (:short_term_goal) { create(:short_term_goal, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				put "/users/#{user.id}/short_term_goals/#{short_term_goal.id}", params: { title: 'new title' }, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated and goal content is updated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				put "/users/#{user.id}/short_term_goals/#{short_term_goal.id}", params: { content: 'new content' }, headers: headers
			end

			it 'should return a 200 code' do
				expect(response).to have_http_status(:ok)
			end

			it 'should return the updated Short Term Goal' do
				expect(json['id']).to eq(short_term_goal.id)
				expect(json['content']).to eq('new content')
			end
		end

		context 'when authenticated and goal is associated with long term goal' do
			let (:long_term_goal) { create(:long_term_goal, { user_id: user.id }) }
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				put "/users/#{user.id}/short_term_goals/#{short_term_goal.id}", params: { long_term_goal_id: long_term_goal.id }, headers: headers
			end

			it 'should return a 200 code' do
				expect(response).to have_http_status(:ok)
			end

			it 'should return the updated Short Term Goal' do
				expect(json['id']).to eq(short_term_goal.id)
				expect(json['long_term_goal_id']).to eq(long_term_goal.id)
			end
		end

	end

	describe 'DELETE /users/:user_id/short_term_goals/:id' do
		let (:user) { create(:user) }
		let (:short_term_goal) { create(:short_term_goal, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				delete "/users/#{user.id}/short_term_goals/#{short_term_goal.id}", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				delete "/users/#{user.id}/short_term_goals/#{short_term_goal.id}", params: {}, headers: headers
			end

			it 'should return a 202 code' do
				expect(response).to have_http_status(:accepted)
			end
		end
	end

end
