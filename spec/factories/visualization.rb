FactoryGirl.define do
  factory :visualization do
    caption { Faker::Lorem.sentence(5) }
    url { Faker::Internet.url }
  end
end
