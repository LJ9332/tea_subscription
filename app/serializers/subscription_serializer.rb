class SubscriptionSerializer
  include JSONAPI::Serializer
  attributes :title, 
             :price, 
             :frequency
end