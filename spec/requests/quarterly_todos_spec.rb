require 'rails_helper'

RSpec.describe 'Quarterly Todos API', type: :request do
	describe 'GET /users/:user_id/quarterly_todos' do
		let (:user) { create(:user) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				get "/users/#{user.id}/quarterly_todos", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				get "/users/#{user.id}/quarterly_todos", params: {}, headers: headers
			end

			it 'should return a 200 status' do
				expect(response).to have_http_status(:ok)
			end
		end

	end

	describe 'POST /users/:user_id/quarterly_todos' do
		let (:user) { create(:user) }
		let (:valid_attributes) { attributes_for(:quarterly_todo) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				post "/users/#{user.id}/quarterly_todos", params: valid_attributes, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				post "/users/#{user.id}/quarterly_todos", params: valid_attributes, headers: headers
			end

			it 'should return a created status' do
				expect(response).to have_http_status(:created)
			end

			it 'should return the created Quarterly Todo' do
				expect(json['id']).to be_truthy
			end
		end
	end

	describe 'PUT /users/:user_id/quarterly_todos/:id' do
		let (:user) { create(:user) }
		let (:quarterly_todo) { create(:quarterly_todo, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				put "/users/#{user.id}/quarterly_todos/#{quarterly_todo.id}", params: { content: 'new content' }, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when it is authenticated and todo content is updated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				put "/users/#{user.id}/quarterly_todos/#{quarterly_todo.id}", params: { content: 'new content' }, headers: headers
			end

			it 'should return a 200 code' do
				expect(response).to have_http_status(:ok)
			end

			it 'should return the updated Quarterly Todo' do
				expect(json['id']).to eq(quarterly_todo.id)
				expect(json['content']).to eq('new content')
			end
		end
	end

	describe 'DELETE /users/:user_id/quarterly_todos/:id' do
		let (:user) { create(:user) }
		let (:quarterly_todo) { create(:quarterly_todo, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				delete "/users/#{user.id}/quarterly_todos/#{quarterly_todo.id}", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				delete "/users/#{user.id}/quarterly_todos/#{quarterly_todo.id}", params: {}, headers: headers
			end

			it 'should return a 202 code' do
				expect(response).to have_http_status(:accepted)
			end
		end
	end

end
