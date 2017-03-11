FactoryGirl.define do
	factory :habit do
		active true
		content { Faker::Lorem.sentence(10) }
	end
end
