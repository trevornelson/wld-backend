FactoryGirl.define do
	factory :long_term_goal do
		category { Faker::Lorem.sentence(2) }
		timeframe { ['3', '5', '10'].sample }
		content { Faker::Lorem.sentence(10) }
	end
end
