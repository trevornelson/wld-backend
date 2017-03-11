FactoryGirl.define do
	factory :short_term_goal do
		category { Faker::Lorem.sentence(2) }
		content { Faker::Lorem.sentence(10) }
	end
end
