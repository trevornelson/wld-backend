require 'rails_helper'

RSpec.describe 'Users API', type: :request do
	describe 'POST /users' do
		let (:valid_attributes) { attributes_for(:user) }

		context 'when the request is valid' do
			before { post '/users', params: valid_attributes }

			it 'returns a 200 status' do
				expect(response).to have_http_status(:created)
			end

			it 'creates a user' do
				expect(json['user']['id']).to be_truthy
				expect(json['user']['first_name']).to eq(valid_attributes[:first_name])
				expect(json['user']['last_name']).to eq(valid_attributes[:last_name])
				expect(json['user']['email']).to eq(valid_attributes[:email])
				expect(json['user']['password_digest']).to be_falsey
			end

			it 'creates core values' do
				expect(json['values']).to be_truthy
				expect(json['values'].length).to eq(3)
			end
		end

		context 'when the request is invalid' do
			before { post '/users', params: { email: valid_attributes[:email], first_name: valid_attributes[:first_name], last_name: valid_attributes[:last_name] } }

			it 'returns a bad request status' do
				expect(response).to have_http_status(:bad_request)
			end
		end

	end

  describe 'GET /users/:id' do
		let (:user) { create(:user, { purpose: 'to do stuff' }) }
    let (:week_start) { DateTime.now.beginning_of_week }

    context 'when the request is authenticated' do
			before do
        @relationship_category = create(:relationship_category, { user_id: user.id })
        @relationship = create(:relationship, { user_id: user.id, relationship_category_id: @relationship_category.id })
        @long_term_goal = create(:long_term_goal, { user_id: user.id })
        @short_term_goal = create(:short_term_goal, { user_id: user.id, long_term_goal_id: @long_term_goal.id })
        @quarterly_todo = create(:quarterly_todo, { user_id: user.id })
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
        @habit = create(:habit, { user_id: user.id })
        @habit_todo = create(:habit_todo, { user_id: user.id, habit_id: @habit.id })
				headers = authenticate_headers(user.email, 'easypassword123')
				get "/users/#{user.id}", params: {}, headers: headers
			end

      it 'responds with a 200 response code' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the dashboard core purpose' do
        expect(json['purpose']).to eq('to do stuff')
      end

      it 'returns the dashboard core values' do
        expect(json['values']).to be
        expect(json['values'].count).to eq(3)
      end

      it 'returns the dashboard relationships' do
        expect(json['relationship_categories']).to be
        expect(json['relationship_categories'][0]['id']).to eq(@relationship_category.id)
        expect(json['relationship_categories'][0]['relationships']).to be
        expect(json['relationship_categories'][0]['relationships'][0]['id']).to eq(@relationship.id)
      end

      it 'returns the dashboard long term goals' do
        expect(json['long_term_goals']).to be
        expect(json['long_term_goals'][0]['id']).to eq(@long_term_goal.id)
      end

      it 'returns the dashboard short term goals' do
        expect(json['short_term_goals']).to be
        expect(json['short_term_goals'][0]['id']).to eq(@short_term_goal.id)
        expect(json['short_term_goals'][0]['long_term_goal']).to be
        expect(json['short_term_goals'][0]['long_term_goal']['id']).to eq(@long_term_goal.id)
      end

      it 'returns the dashboard quarterly todos' do
        expect(json['quarterly_todos']).to be
        expect(json['quarterly_todos'][0]['id']).to eq(@quarterly_todo.id)
      end

      it 'returns the dashboard daily todos' do
        expect(json['recent_todos']).to be
        expect(json['recent_todos'].length).to eq(7)
        7.times do |i|
          expect(json['recent_todos'][i]['due_date']).to eq((week_start + i.days).strftime('%Y-%m-%d'))
        end
      end
    end

    context 'when the request is unauthenticated' do
			before do
				headers = authenticate_headers(user.email, 'wrongpassword')
				get "/users/#{user.id}", params: {}, headers: headers
			end

      it 'responds with an unauthorized response code' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
