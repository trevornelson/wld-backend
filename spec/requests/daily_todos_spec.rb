require 'rails_helper'

RSpec.describe 'Daily Todos API', type: :request do
	describe 'GET /users/:user_id/daily_todos' do
		let (:user) { create(:user) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				get "/users/#{user.id}/daily_todos", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				get "/users/#{user.id}/daily_todos", params: {}, headers: headers
			end

			it 'should return a 200 status' do
				expect(response).to have_http_status(:ok)
			end
		end

	end

  describe 'GET /users/:user_id/daily_todos/prev/:number_of_weeks' do
    let (:user) { create(:user) }
    let (:last_week) { 1.week.ago }
    let (:week_start) { last_week.beginning_of_week(start_day = :sunday) }
    let (:week_end) { last_week.end_of_week(start_day = :sunday) }

    before do
      create(:daily_todo, { user_id: user.id, due_date: week_start })
      10.times do |i|
        n = i + 1
        create(:daily_todo, {
          user_id: user.id,
          due_date: week_start - n.days
        })
        create(:daily_todo, {
          user_id: user.id,
          due_date: week_start + n.days
        })
      end
    end

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				get "/users/#{user.id}/daily_todos/prev/1", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				get "/users/#{user.id}/daily_todos/prev/1", params: {}, headers: headers
			end

			it 'should return a 200 status' do
				expect(response).to have_http_status(:ok)
			end

      it 'should return todos for last week' do
        expect(json.length).to eq(7)
        json.each do |todo|
          expect(Time.parse(todo['due_date']))
            .to be >= week_start

          expect(Time.parse(todo['due_date']))
            .to be <= week_end
        end
      end
		end

  end

  describe 'GET /users/:user_id/daily_todos/next/:number_of_weeks' do
    let (:user) { create(:user) }
    let (:next_week) { 1.week.from_now }
    let (:week_start) { next_week.beginning_of_week(start_day = :sunday) }
    let (:week_end) { next_week.end_of_week(start_day = :sunday) }

    before do
      create(:daily_todo, { user_id: user.id, due_date: week_start })
      10.times do |i|
        n = i + 1
        create(:daily_todo, {
          user_id: user.id,
          due_date: week_start - n.days
        })
        create(:daily_todo, {
          user_id: user.id,
          due_date: week_start + n.days
        })
      end
    end

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				get "/users/#{user.id}/daily_todos/next/1", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				get "/users/#{user.id}/daily_todos/next/1", params: {}, headers: headers
			end

			it 'should return a 200 status' do
				expect(response).to have_http_status(:ok)
			end

      it 'should return todos for next week' do
        expect(json.length).to eq(7)
        json.each do |todo|
          expect(Time.parse(todo['due_date']))
            .to be >= week_start

          expect(Time.parse(todo['due_date']))
            .to be <= week_end
        end
      end
		end

  end

	describe 'POST /users/:user_id/daily_todos' do
		let (:user) { create(:user) }
		let (:valid_attributes) { attributes_for(:daily_todo) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				post "/users/#{user.id}/daily_todos", params: valid_attributes, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				post "/users/#{user.id}/daily_todos", params: valid_attributes, headers: headers
			end

			it 'should return a created status' do
				expect(response).to have_http_status(:created)
			end

			it 'should return the created Daily Todo' do
				expect(json['id']).to be_truthy
			end
		end
	end

	describe 'PUT /users/:user_id/daily_todos/:id' do
		let (:user) { create(:user) }
		let (:daily_todo) { create(:daily_todo, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				put "/users/#{user.id}/daily_todos/#{daily_todo.id}", params: { content: 'new content' }, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when it is authenticated and todo content is updated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				put "/users/#{user.id}/daily_todos/#{daily_todo.id}", params: { content: 'new content' }, headers: headers
			end

			it 'should return a 200 code' do
				expect(response).to have_http_status(:ok)
			end

			it 'should return the updated Daily Todo' do
				expect(json['id']).to eq(daily_todo.id)
				expect(json['content']).to eq('new content')
			end
		end

		context 'when it is authenticated and todo is completed' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				put "/users/#{user.id}/daily_todos/#{daily_todo.id}", params: { completed: true }, headers: headers
			end

			it 'should return a 200 code' do
				expect(response).to have_http_status(:ok)
			end

			it 'should return the updated Daily Todo' do
				expect(json['id']).to eq(daily_todo.id)
				expect(json['completed']).to be_truthy
			end
		end
	end

	describe 'DELETE /users/:user_id/daily_todos/:id' do
		let (:user) { create(:user) }
		let (:daily_todo) { create(:daily_todo, { user_id: user.id }) }

		context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				delete "/users/#{user.id}/daily_todos/#{daily_todo.id}", params: {}, headers: headers
			end

			it 'should return an unauthorized status' do
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'when the request is authenticated' do
			before do
				headers = authenticate_headers(user.email, 'easypassword123')
				delete "/users/#{user.id}/daily_todos/#{daily_todo.id}", params: {}, headers: headers
			end

			it 'should return a 202 code' do
				expect(response).to have_http_status(:accepted)
			end
		end
	end

end
