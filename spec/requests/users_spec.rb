require 'rails_helper'

RSpec.describe 'Users API', type: :request do
	describe 'POST /users' do
		let (:valid_attributes) { attributes_for(:user) }

		context 'when the request is valid' do
			before { post '/users', params: valid_attributes }

			it 'creates a user' do
				expect(json['id']).to be_truthy
			end
		end
	end
end
