require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
	describe 'POST authenticate' do
		let(:user) { create(:user) }

		context 'with incorrect credentials' do
			it 'returns a 401 status code' do
				post :authenticate, params: { email: user.email, password: 'thisiswrong' }
				expect(response).to have_http_status(:unauthorized)
			end
		end

		context 'with correct credentials' do
			it 'returns a 200 status code' do
				post :authenticate, params: { email: user.email, password: 'easypassword123' }
				expect(response).to have_http_status(:ok)
			end
		end

	end
end
