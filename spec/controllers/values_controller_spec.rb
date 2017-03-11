require 'rails_helper'

RSpec.describe ValuesController, type: :controller do
	describe 'GET index' do
		let(:user) { create(:user) }

		before do
			2.times do
				create(:value, user_id: user.id)
			end
		end

		it 'should return a 200 response code' do
			get :index, params: { user_id: user.id }
			expect(response).to have_http_status(:ok)
		end

		it 'should return the correct values' do
			get :index, params: { user_id: user.id }
			expect(response.body).to eq(2) 
		end


	end

	describe 'POST create' do

	end

	describe 'PUT update' do

	end

	describe 'DELETE destroy' do

	end
end
