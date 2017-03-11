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
end
