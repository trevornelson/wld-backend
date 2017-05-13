require 'rails_helper'

RSpec.describe 'Long Term Goals API', type: :request do
	describe 'GET /users/:user_id/long_term_goals' do
		let (:user) { create(:user) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				get "/users/#{user.id}/long_term_goals", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				get "/users/#{user.id}/long_term_goals", params: {}, headers: headers
			end

			it 'should return a 200 status' do
				expect(response).to have_http_status(:ok)
			end
		end

	end

	describe 'POST /users/:user_id/long_term_goals' do
		let (:user) { create(:user) }
		let (:valid_attributes) { attributes_for(:long_term_goal) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				post "/users/#{user.id}/long_term_goals", params: valid_attributes, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				post "/users/#{user.id}/long_term_goals", params: valid_attributes, headers: headers
			end

			it 'should return a created status' do
				expect(response).to have_http_status(:created)
			end

			it 'should return the created Long Term Goal' do
				expect(json['id']).to be_truthy
			end
		end
	end

	describe 'PUT /users/:user_id/long_term_goals/:id' do
		let (:user) { create(:user) }
		let (:long_term_goal) { create(:long_term_goal, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				put "/users/#{user.id}/long_term_goals/#{long_term_goal.id}",
					params: { category: 'Personal', timeframe: '5', content: 'new content' },
					headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				put "/users/#{user.id}/long_term_goals/#{long_term_goal.id}",
					params: { category: 'Personal', timeframe: '5', content: 'new content' },
					headers: headers
			end

			it 'should return a 200 code' do
				expect(response).to have_http_status(:ok)
			end

			it 'should return the updated Long Term Goal' do
				expect(json['id']).to eq(long_term_goal.id)
				expect(json['content']).to eq('new content')
			end
		end
	end

	describe 'DELETE /users/:user_id/long_term_goals/:id' do
		let (:user) { create(:user) }
		let (:long_term_goal) { create(:long_term_goal, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				delete "/users/#{user.id}/long_term_goals/#{long_term_goal.id}", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				delete "/users/#{user.id}/long_term_goals/#{long_term_goal.id}", params: {}, headers: headers
			end

			it 'should return a 202 code' do
				expect(response).to have_http_status(:accepted)
			end
		end
	end

end
