FactoryGirl.define do
	factory :value do
		content { Faker::Lorem.sentence(10) }
	end
end
