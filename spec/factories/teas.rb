FactoryBot.define do
  factory :tea do
    title { Faker::Company.unique.name }
    description { Faker::Lorem.sentence }
    temperature { Faker::Number.between(from: 1, to: 99)  }
    brew_time { Faker::Number.between(from: 1, to: 25) }
  end
end