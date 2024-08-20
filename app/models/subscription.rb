class Subscription < ApplicationRecord
  has_many :customer_subscriptions, dependent: :destroy
  has_many :customers, through: :customer_subscriptions
  has_many :tea_subscriptions
  has_many :teas, through: :tea_subscriptions
end