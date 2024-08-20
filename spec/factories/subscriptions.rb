FactoryBot.define do
  factory :subscription do
    title { Faker::Tea.type }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    frequency { Faker::Number.between(from: 1, to: 10)   }
  end
end