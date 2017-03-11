# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

test_user = User.create(
	first_name: 'Bob',
	last_name: 'Glazer',
	email: 'rglazer@accelerationpartners.com',
	password: 'ap123',
	password_confirmation: 'ap123'
)

2.times do
	test_user.values.create(
		content: Faker::Lorem.sentence(10)
	)
end

['Work', 'Family', 'Friends'].each do |category_name|
	category = test_user.relationship_categories.create(
		title: category_name
	)

	rand(3..9).times do
		category.relationships.create(
			user_id: test_user.id,
			content: Faker::StarWars.character
		)
	end
end


3.times do
	habit = test_user.habits.create(
		active: true,
		content: Faker::Lorem.sentence(4)
	)

	# Create habit_todos here?
end

['Personal', 'Family', 'Business', 'Community'].each do |category_name|
	[3, 5, 10].each do |timeframe|
		rand(1..5).times do
			long_goal = test_user.long_term_goals.create(
				category: category_name,
				timeframe: timeframe,
				content: Faker::Lorem.sentence(6)
			)

			long_goal.short_term_goals.create(
				user_id: test_user.id,
				category: category_name,
				content: Faker::Lorem.sentence(4)
			)
		end
	end
end


['Open', 'Ongoing', 'Done', 'Hold'].each do |category_name|
	rand(1..4).times do
		test_user.quarterly_todos.create(
			category: category_name,
			content: Faker::Lorem.sentence(5)
		)
	end
end


today = Date.new
10.times do |i|
	day = today + i
	test_user.daily_todos.create(
		due_date: day,
		content: Faker::Lorem.sentence(4)
	)
end




