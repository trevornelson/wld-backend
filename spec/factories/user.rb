FactoryGirl.define do
	factory :user do
		first_name { Faker::Name.first_name }
		last_name { Faker::Name.last_name }
		email { Faker::Internet.email }
		password 'easypassword123'
		password_confirmation 'easypassword123'
	end
end
