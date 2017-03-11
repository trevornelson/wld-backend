FactoryGirl.define do
	factory :relationship_category do
		title { Faker::Lorem.sentence(2) }
	end
end
