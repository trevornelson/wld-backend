require 'rails_helper'

RSpec.describe 'Habits API', type: :request do
	describe 'POST /users/:user_id/habits' do
		let (:user) { create(:user) }
		let (:valid_attributes) { attributes_for(:habit) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				post "/users/#{user.id}/habits", params: valid_attributes, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				post "/users/#{user.id}/habits", params: valid_attributes, headers: headers
			end

			it 'should return a created status' do
				expect(response).to have_http_status(:created)
			end

			it 'should return the created habit' do
				expect(json['id']).to be_truthy
			end
		end
	end

	describe 'PUT /users/:user_id/habits/:id' do
		let (:user) { create(:user) }
		let (:habit) { create(:habit, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				put "/users/#{user.id}/habits/#{habit.id}", params: { content: 'new content' }, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when it is authenticated and habit content is updated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				put "/users/#{user.id}/habits/#{habit.id}", params: { content: 'new content' }, headers: headers
			end

			it 'should return a 200 code' do
				expect(response).to have_http_status(:ok)
			end

			it 'should return the updated habit' do
				expect(json['id']).to eq(habit.id)
				expect(json['content']).to eq('new content')
			end
		end
	end

	describe 'DELETE /users/:user_id/habits/:id' do
		let (:user) { create(:user) }
		let (:habit) { create(:habit, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				delete "/users/#{user.id}/habits/#{habit.id}", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				delete "/users/#{user.id}/habits/#{habit.id}", params: {}, headers: headers
			end

			it 'should return a 202 code' do
				expect(response).to have_http_status(:accepted)
			end

      it 'should soft delete the habit' do
        expect(Habit.last.id).to eq(habit.id)
        expect(Habit.last.active).to be_falsey
      end
		end
	end
end
