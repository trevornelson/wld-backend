FactoryGirl.define do
	factory :quarterly_todo do
		category { Faker::Lorem.sentence(2) }
		content { Faker::Lorem.sentence(10) }
	end
end
