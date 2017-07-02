FactoryGirl.define do
  factory :affirmation do
    content { Faker::Lorem.sentence(10) }
  end
end
