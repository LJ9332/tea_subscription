class CustomerSubscriptionSerializer
  include JSONAPI::Serializer
  attributes :status

  belongs_to :customer
  belongs_to :subscription
end
