FactoryGirl.define do
	factory :relationship do
		content { Faker::StarWars.character }
	end
end
