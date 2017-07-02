require 'rails_helper'

RSpec.describe 'Habit Todos API', type: :request do
	describe 'POST /users/:user_id/habit_todos' do
		let (:user) { create(:user) }
    let (:habit) { create(:habit, { user_id: user.id }) }
    let (:attributes) { attributes_for(:habit_todo, { habit_id: habit.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				post "/users/#{user.id}/habit_todos", params: attributes, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				post "/users/#{user.id}/habit_todos", params: attributes, headers: headers
			end

      context 'when the request params are valid' do
        it 'should return a created status' do
          expect(response).to have_http_status(:created)
        end

        it 'should return the created habit todo' do
          expect(json['id']).to be_truthy
        end
      end

      context 'when the date is in the future' do
        let (:attributes) { attributes_for(:habit_todo, { habit_id: habit.id, due_date: Date.today.next_year }) }

        it 'should return a bad request status code' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'should return the correct error message' do
          expect(json['message']).to eq('You cannot mark future daily habits as complete.')
        end
      end

      context 'when the user does not match the habits user' do
        let (:some_other_user) { create(:user) }
        let (:other_users_habit) { create(:habit, { user_id: some_other_user.id }) }
        let (:attributes) { attributes_for(:habit_todo, { habit_id: other_users_habit.id }) }

        it 'should return an unauthorized status code' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'should return the correct error message' do
          expect(json['message']).to eq('Hmm, something went wrong.')
        end
      end
		end
	end

	describe 'DELETE /users/:user_id/habit_todos/:id' do
		let (:user) { create(:user) }
    let (:habit) { create(:habit, { user_id: user.id }) }
    let (:habit_todo) { create(:habit_todo, { user_id: user.id, habit_id: habit.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				delete "/users/#{user.id}/habit_todos/#{habit_todo.id}", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				delete "/users/#{user.id}/habit_todos/#{habit_todo.id}", params: {}, headers: headers
			end

			it 'should return a 202 code' do
				expect(response).to have_http_status(:accepted)
			end
		end
	end
end
