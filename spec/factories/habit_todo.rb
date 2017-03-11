FactoryGirl.define do
	factory :habit_todo do
		due_date { Faker::Date.between(2.days.ago, Date.today) }
		completed false
	end
end
