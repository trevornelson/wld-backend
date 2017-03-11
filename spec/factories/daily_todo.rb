FactoryGirl.define do
	factory :daily_todo do
		due_date { Faker::Date.between(2.days.ago, Date.today) }
		content { Faker::Lorem.sentence(10) }
	end
end
