require 'rails_helper'

RSpec.describe 'Authentication API', type: :request do
	describe 'POST /authenticate' do
		let (:user) { create(:user) }

		context 'with correct credentials' do
			before { post '/authenticate', params: { email: user.email, password: 'easypassword123' } }
			it 'returns a 200 status' do
				expect(response).to have_http_status(:ok)
			end

			it 'returns a token' do
				expect(json['auth_token']).to be_truthy
			end

			it 'finds the correct user' do
				expect(json['user']['id']).to eq(user.id)
				expect(json['user']['first_name']).to eq(user.first_name)
				expect(json['user']['last_name']).to eq(user.last_name)
				expect(json['user']['email']).to eq(user.email)
				expect(json['user']['password_digest']).to be_falsey
			end

			it 'includes core values' do
				expect(json['values']).to be_truthy
				expect(json['values'].length).to eq(3)
			end
		end

		context 'with incorrect credentials' do
			before { post '/authenticate', params: { email: user.email, password: 'wrongpassword' } }

			it 'returns a bad request status' do
				expect(response).to have_http_status(:unauthorized)
			end

			it 'does not return a token' do
				expect(json['auth_token']).to be_falsey
			end
		end

	end
end
