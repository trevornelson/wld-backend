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
				expect(json['id']).to be_truthy
			end
		end

		context 'when the request is invalid' do
			before { post '/users', params: { email: valid_attributes[:email], first_name: valid_attributes[:first_name], last_name: valid_attributes[:last_name] } }

			it 'returns a bad request status' do
				expect(response).to have_http_status(:bad_request)
			end
		end

	end
end
