require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	describe 'POST create' do
		let(:user) { build(:user) }

		context 'has valid inputs' do

			it 'returns a created status code' do
				post :create, params: { email: user.email, password: 'easypassword123', password_confirmation: 'easypassword123', first_name: user.first_name, last_name: user.last_name }
				expect(response).to have_http_status(:created)
			end

		end

		context 'has incomplete inputs' do

			it 'returns a bad request status code' do
				post :create, params: { email: user.email, password: 'easypassword123' }
				expect(response).to have_http_status(:bad_request)
			end

		end

	end
end
