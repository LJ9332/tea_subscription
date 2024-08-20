class CustomerSubscription < ApplicationRecord
  belongs_to :customer
  belongs_to :subscription
  
  validates :customer_id, presence: true
  validates :subscription_id, presence: true
  
  enum :status, { active: 0, cancelled: 1 }
end
