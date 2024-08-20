FactoryBot.define do
  factory :customer_subscription do
    association :customer
    association :subscription 
    status { 0 }
  end
end